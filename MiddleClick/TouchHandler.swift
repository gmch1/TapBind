import Carbon.HIToolbox
import MoreTouchCore
import MultitouchSupport

@MainActor class TouchHandler {
  static let shared = TouchHandler()
  private static let config = Config.shared
  private init() {
    Self.config.$tapToClick.onSet {
      self.tapToClick = $0
    }
    Self.config.$minimumFingers.onSet {
      Self.fingersQua = $0
    }
  }

  /// stored locally, since accessing the cache is more CPU-expensive than a local variable
  private var tapToClick = config.tapToClick

  private static var fingersQua = config.minimumFingers
  private static let allowMoreFingers = config.allowMoreFingers
  private static let maxDistanceDelta = config.maxDistanceDelta
  private static let maxTimeDelta = config.maxTimeDelta

  private var maybeShortcutTrigger = false
  private var touchStartTime: Date?
  private var touchStartPos: SIMD2<Float> = .zero
  private var touchEndPos: SIMD2<Float> = .zero

  private let touchCallback: MTFrameCallbackFunction = {
    _, data, nFingers, _, _ in
    guard !AppUtils.isIgnoredAppBundle() else { return }

    let state = GlobalState.shared

    state.threeDown =
    allowMoreFingers ? nFingers >= fingersQua : nFingers == fingersQua

    let handler = TouchHandler.shared

    guard handler.tapToClick else { return }

    guard nFingers != 0 else {
      handler.handleTouchEnd()
      return
    }

    let isTouchStart = nFingers > 0 && handler.touchStartTime == nil
    if isTouchStart {
      handler.touchStartTime = Date()
      handler.maybeShortcutTrigger = true
      handler.touchStartPos = .zero
    } else if handler.maybeShortcutTrigger, let touchStartTime = handler.touchStartTime {
      // Timeout check for the tap-triggered shortcut
      let elapsedTime = -touchStartTime.timeIntervalSinceNow
      if elapsedTime > maxTimeDelta {
        handler.maybeShortcutTrigger = false
      }
    }

    guard !(nFingers < fingersQua) else { return }

    if !allowMoreFingers && nFingers > fingersQua {
      handler.resetShortcutTrigger()
    }

    let isCurrentFingersQuaAllowed = allowMoreFingers ? nFingers >= fingersQua : nFingers == fingersQua
    guard isCurrentFingersQuaAllowed else { return }

    handler.processTouches(data: data, nFingers: nFingers)

    return
  }

  private func processTouches(data: UnsafePointer<MTTouch>?, nFingers: Int32) {
    guard let data = data else { return }

    if maybeShortcutTrigger {
      touchStartPos = .zero
    } else {
      touchEndPos = .zero
    }

//    TODO: Wait, what? Why is this iterating by fingersQua instead of nFingers, given that e.g. "allowMoreFingers" exists?
    for touch in UnsafeBufferPointer(start: data, count: Self.fingersQua) {
      let pos = SIMD2(touch.normalizedVector.position)
      if maybeShortcutTrigger {
        touchStartPos += pos
      } else {
        touchEndPos += pos
      }
    }

    if maybeShortcutTrigger {
      touchEndPos = touchStartPos
      maybeShortcutTrigger = false
    }
  }

  private func resetShortcutTrigger() {
    maybeShortcutTrigger = false
    touchStartPos = .zero
  }

  private func handleTouchEnd() {
    guard let startTime = touchStartTime else { return }

    let elapsedTime = -startTime.timeIntervalSinceNow
    touchStartTime = nil

    guard touchStartPos.isNonZero && elapsedTime <= Self.maxTimeDelta else { return }

    let delta = touchStartPos.delta(to: touchEndPos)
    if delta < Self.maxDistanceDelta {
      GestureShortcut.performCommandW()
    }
  }

  private var currentDeviceList: [MTDevice] = []
  func registerTouchCallback() {
    currentDeviceList = MTDevice.createList()
    currentDeviceList.forEach { $0.registerAndStart(touchCallback) }
  }
  func unregisterTouchCallback() {
    currentDeviceList.forEach { $0.unregisterAndStop(touchCallback) }
    currentDeviceList.removeAll()
  }
}

extension SIMD2 where Scalar == Float {
  init(_ point: MTPoint) { self.init(point.x, point.y) }
}
extension SIMD2 where Scalar: FloatingPoint {
  func delta(to other: SIMD2) -> Scalar {
    return abs(x - other.x) + abs(y - other.y)
  }

  var isNonZero: Bool { x != 0 || y != 0 }
}

enum GestureShortcut {
  private static let commandKeyCode = CGKeyCode(kVK_Command)
  private static let wKeyCode = CGKeyCode(kVK_ANSI_W)

  @MainActor
  static func performCommandW() {
    if let lastTime = GlobalState.shared.lastShortcutTriggerTime,
       -lastTime.timeIntervalSinceNow < Config.shared.maxTimeDelta * 0.75 {
      return
    }
    GlobalState.shared.lastShortcutTriggerTime = .init()

    let events: [(CGKeyCode, Bool, CGEventFlags)] = [
      (commandKeyCode, true, .maskCommand),
      (wKeyCode, true, .maskCommand),
      (wKeyCode, false, .maskCommand),
      (commandKeyCode, false, [])
    ]

    for (keyCode, keyDown, flags) in events {
      guard let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown) else {
        continue
      }
      event.flags = flags
      event.post(tap: .cghidEventTap)
    }
  }
}
