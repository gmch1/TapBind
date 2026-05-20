<a href="https://github.com/gmch1/TapBind/releases">
  <img align="right" src="https://img.shields.io/github/downloads/gmch1/TapBind/total?color=teal" title="GitHub All Releases">
</a>

<div align="center">
  <h1>
    TapBind <img align="center" height="80" src="MiddleClick/Images.xcassets/AppIcon.appiconset/icon_128p.png">
  </h1>
  <p>
    <b>Trigger <code>Command+W</code> with a three finger Click or Tap on MacBook trackpad and Magic Mouse</b>
  </p>
  <p>
    with <b>macOS</b> Sequoia<a href="https://www.apple.com/macos/macos-sequoia/"><sup>15</sup></a> support!
  </p>
  <br>
</div>

<img src="demo.png" width="55%">

<h2 align="right">:mag: Usage</h2>

<blockquote align="right">

Three fingers can close more than tabs

</blockquote>

<p align="right">

`System-wide` · close the current tab or window with a three-finger gesture

</p>

<p align="right">

`In Safari` · quickly close the active tab with `Command+W`

</p>

<p align="right">

`In Finder` · close the frontmost window without reaching for the keyboard

</p>

<br>

## Install

### Via :beer: [Homebrew](https://brew.sh) (Recommended)

```ps1
brew install --cask middleclick
```

> Check out [the cask](https://github.com/Homebrew/homebrew-cask/blob/master/Casks/m/middleclick.rb) if you're interested

### <a href="https://github.com/gmch1/TapBind/releases/latest/download/TapBind.zip">Direct Download · <img align="center" alt="GitHub release" src="https://img.shields.io/github/release/gmch1/TapBind?label=%20&color=gray"></a>

If you've used v1 or v2 — glance over [How to migrate](./docs/MIGRATIONS.md).

<br>

## Preferences

### Hide Status Bar Item

> This is a native macOS feature — works the same for any app.

1. Hold `⌘` and drag the icon away from the menu bar until you see :heavy_multiplication_x:
2. Release

To bring it back — just open TapBind again while it's already running.

### Number of Fingers

- Want to use 4, 5 or 2 fingers for triggering `Command+W`? No trouble. Even 10 is possible.
- **Note:** setting `fingers` to `2` will conflict with normal two-finger right-clicks and single-finger clicks.

```ps1
defaults write art.ginzburg.TapBind fingers 4
```

> Default is 3

### Allow more than the defined number of fingers

- This is useful if your second hand accidentally touches the touchpad.
- Unfortunately, this does not serve as a palm rejection technique for huge touchpads.

```ps1
defaults write art.ginzburg.TapBind allowMoreFingers true
```

> Default is false, so that the number of fingers is precise

### Tap trigger preferences

#### Max Distance Delta

- The maximum distance the cursor can travel between touch and release for a tap to be considered valid.
- The position is normalized and values go from 0 to 1.

```ps1
defaults write art.ginzburg.TapBind maxDistanceDelta 0.03
```

> Default is 0.05

#### Max Time Delta

- The maximum interval in milliseconds between touch and release for a tap to be considered valid.

```ps1
defaults write art.ginzburg.TapBind maxTimeDelta 150
```

> Default is 300

## Troubleshooting

- [Accessibility permissions not working after an update](./docs/troubleshooting.md#accessibility-permissions-not-working-after-an-update)
- [Antivirus / CleanMyMac false positive](./docs/troubleshooting.md#antivirus--cleanmymac-flags-tapbind-as-adware)
- [Three Finger Drag conflicts](./docs/three-finger-drag.md)

## Building from source

> Assuming you have `Command Line Tools` installed

1. Clone the repo
2. Run `make`
3. You'll get a `TapBind.app` in `./build/`

## Credits

Created by [Clément Beffa](https://clement.beffa.org/),<br/>
fixed by [Alex Galonsky](https://github.com/galonsky) and [Carlos E. Hernandez](https://github.com/carlosh),<br/>
revived by [Pascâl Hartmann](https://github.com/LoPablo),<br/>
maintained by [Arthur Ginzburg](https://github.com/artginzburg)
