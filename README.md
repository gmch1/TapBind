**English** | [简体中文](./README.zh-CN.md)

<div align="center">
  <h1>
    TapBind <img align="center" height="80" src="MiddleClick/Images.xcassets/AppIcon.appiconset/icon_128p.png">
  </h1>
  <p>
    <b>Close the frontmost tab or window with a multitouch gesture on your Mac trackpad or Magic Mouse</b>
  </p>
  <p>
    A fork of <a href="https://github.com/artginzburg/MiddleClick">MiddleClick</a> — same multitouch engine, different goal.
  </p>
  <br>
</div>

<img src="demo.png" width="55%">

## What TapBind does

TapBind listens to your trackpad / Magic Mouse through Apple's private multitouch APIs and sends **`⌘W` (`Command+W`)** when you perform a configured finger gesture.

That shortcut closes the active tab in browsers and many editors, or closes the frontmost window in apps like Finder — **without reaching for the keyboard**.

### How it triggers

| Mode | When it fires | Default |
|------|----------------|---------|
| **Click** | You press the trackpad button (physical click) while the configured number of fingers is touching the surface | Always on |
| **Tap** | You perform a short, stationary multi-finger tap (no button press) | Follows the menu toggle *Also trigger on tap* (initially aligned with the system "Tap to click" setting) |

By default the gesture uses **3 fingers** (exactly 3, not "3 or more"). You can change the count from the menu bar under **Advanced**, or with `defaults` (see below).

### What changed vs. upstream MiddleClick

| | [MiddleClick](https://github.com/artginzburg/MiddleClick) | **TapBind** (this repo) |
|--|--|--|
| Primary action | Emulates a **middle mouse button** click | Sends **`Command+W`** |
| Typical use | Open links in new tabs, paste, app-specific middle-click actions | **Close tab / close window** |
| Bundle ID | `art.ginzburg.MiddleClick` | `art.ginzburg.TapBind` |
| Distribution | Homebrew `middleclick`, upstream releases | Build from source in this repo (see below) |

TapBind is **not** a drop-in replacement for an installed MiddleClick app. Treat it as a separate app: new permissions, new preferences, new bundle.

## Examples

- **Safari / Chrome / Firefox** — three-finger click to close the current tab
- **VS Code / Terminal tabs** — same gesture where `⌘W` closes the active tab
- **Finder** — close the frontmost window when the app uses `⌘W` for that

> TapBind only sends the shortcut. Whether something closes depends on the focused app and whether `⌘W` is bound to "close tab" or "close window" there.

## Requirements

- macOS (tested on recent releases including Sequoia)
- **Accessibility** permission (System Settings → Privacy & Security → Accessibility)
- Built-in trackpad or Magic Mouse supported by multitouch

## Install & build

This repository **does not ship pre-built downloads**. The `build/` directory (including any `.zip` you create locally) is [gitignored](./.gitignore) and never committed. Install by building on your Mac with **Xcode**.

> The Homebrew cask [`middleclick`](https://github.com/Homebrew/homebrew-cask/blob/master/Casks/m/middleclick.rb) installs **upstream MiddleClick**, not TapBind.

### Build and run (local use)

```sh
git clone https://github.com/gmch1/TapBind.git
cd TapBind
make run
```

`make run` builds a Debug `TapBind.app` (unsigned) and launches it. Output path:

```text
build/DerivedData/Build/Products/Debug/TapBind.app
```

Force a full rebuild if Make says nothing to do but you changed code or deleted the app:

```sh
make force-build
# or: make clean-build && make build-debug
```

Copy to Applications (optional):

```sh
cp -R build/DerivedData/Build/Products/Debug/TapBind.app /Applications/
open /Applications/TapBind.app
```

Grant **Accessibility** when prompted (System Settings → Privacy & Security → Accessibility).

### Package a zip for someone else

After `make build-debug` (or `make run`), create a shareable archive:

```sh
APP="build/DerivedData/Build/Products/Debug/TapBind.app"
ditto -c -k --keepParent "$APP" build/TapBind-test.zip
```

Send `build/TapBind-test.zip` (e.g. chat, email, issue attachment). Recipients **do not** need to clone the repo — they unzip and run:

```sh
unzip TapBind-test.zip
xattr -cr TapBind.app
open TapBind.app
```

Each Mac must grant **Accessibility** to that copy of TapBind. Debug builds are **unsigned**; Gatekeeper may require `xattr -cr` or **Right-click → Open** the first time.

**Notes when sharing:**

- Builds on Apple Silicon are **arm64**; Intel Macs need a build made on that machine.
- TapBind uses bundle ID `art.ginzburg.TapBind` — settings and permissions do not carry over from MiddleClick.

## First run

1. Launch **TapBind** — a menu bar icon appears (you can hide it later with ⌘-drag).
2. Allow **Accessibility** if asked.
3. Try a **three-finger click** on the trackpad in Safari or another app.
4. Use the menu to tune behavior:
   - **Also trigger on tap** — enable light tap in addition to physical click
   - **Advanced → finger count** — e.g. switch to 4 fingers to avoid conflicts with system three-finger gestures
   - **Ignore focused app** — disable TapBind for the current app (useful for Finder + Three Finger Drag)
   - **Launch at login**

If you use **Three Finger Drag** or **Tap with Three Fingers** in System Settings, read [three-finger-drag.md](./docs/three-finger-drag.md) — TapBind will warn you when 3-finger mode may conflict.

## Preferences (menu bar & `defaults`)

### Hide the menu bar icon

Hold **⌘** and drag the icon out of the menu bar. Open TapBind again while it is running to bring the menu back.

### Finger count

Default: **3** (exact count). Example — use four fingers:

```sh
defaults write art.ginzburg.TapBind fingers 4
```

> Using **2** fingers conflicts with normal scrolling and clicking.

### Allow more than the configured count

Useful if an extra finger sometimes rests on the pad:

```sh
defaults write art.ginzburg.TapBind allowMoreFingers true
```

Default: `false` (gesture must match the count exactly).

### Tap sensitivity

**Max distance delta** (normalized 0–1, default `0.05`):

```sh
defaults write art.ginzburg.TapBind maxDistanceDelta 0.03
```

**Max time delta** (milliseconds, default `300`):

```sh
defaults write art.ginzburg.TapBind maxTimeDelta 150
```

## Troubleshooting

- [Accessibility after an update](./docs/troubleshooting.md#accessibility-permissions-not-working-after-an-update)
- [Antivirus false positives](./docs/troubleshooting.md#antivirus--cleanmymac-flags-tapbind-as-adware)
- [Three Finger Drag & system gesture conflicts](./docs/three-finger-drag.md)

## Credits & license

TapBind is maintained in [this repository](https://github.com/gmch1/TapBind).

It is derived from [MiddleClick](https://github.com/artginzburg/MiddleClick), originally created by [Clément Beffa](https://clement.beffa.org/), with contributions from [Alex Galonsky](https://github.com/galonsky), [Carlos E. Hernandez](https://github.com/carlosh), [Pascâl Hartmann](https://github.com/LoPablo), and [Arthur Ginzburg](https://github.com/artginzburg). The multitouch approach and much of the infrastructure come from that project; the **Command+W shortcut behavior and TapBind branding are specific to this fork**.
