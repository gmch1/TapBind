[English](./README.md) | **简体中文**

<div align="center">
  <h1>
    TapBind <img align="center" height="80" src="MiddleClick/Images.xcassets/AppIcon.appiconset/icon_128p.png">
  </h1>
  <p>
    <b>在 Mac 触控板或妙控鼠标上，用多指手势关闭当前标签页或窗口</b>
  </p>
  <p>
    基于 <a href="https://github.com/artginzburg/MiddleClick">MiddleClick</a> 的分支 — 复用同一套多点触控能力，目标不同。
  </p>
  <br>
</div>

<img src="demo.png" width="55%">

## TapBind 做什么

TapBind 通过 Apple 私有的多点触控接口监听触控板 / 妙控鼠标，在你完成设定的多指手势后，自动发送 **`⌘W`（Command+W）**。

该快捷键可在浏览器和多数编辑器里关闭当前标签，在 Finder 等应用中关闭最前窗口 — **无需伸手去按键盘**。

### 两种触发方式

| 模式 | 何时触发 | 默认 |
|------|----------|------|
| **点击（Click）** | 指定数量的手指贴在触控板上，再按下物理按键（咔哒一声） | 始终开启 |
| **轻点（Tap）** | 多指在触控板上做一次短促、几乎不移动的轻点（不按物理键） | 由菜单项「Also trigger on tap / 轻点也可触发」控制（首次启动时通常与系统「轻点点按」设置一致） |

默认手势为 **3 根手指**（必须恰好 3 指，不是「3 指及以上」）。可在菜单栏 **Advanced** 中修改，也可用 `defaults` 命令（见下文）。

### 与上游 MiddleClick 的区别

| | [MiddleClick](https://github.com/artginzburg/MiddleClick)（原版） | **TapBind**（本仓库） |
|--|--|--|
| 主要动作 | 模拟 **鼠标中键** 点击 | 发送 **`Command+W`** |
| 典型用途 | 新标签打开链接、粘贴、各应用中键功能 | **关闭标签 / 关闭窗口** |
| Bundle ID | `art.ginzburg.MiddleClick` | `art.ginzburg.TapBind` |
| 分发 | Homebrew `middleclick`、上游 Release | 在本仓库 **从源码构建**（见下文） |

TapBind **不能**直接替代已安装的 MiddleClick，请当作独立应用：新的权限、新的偏好设置、新的 Bundle。

## 使用场景

- **Safari / Chrome / Firefox** — 三指点击关闭当前标签
- **VS Code / 终端多标签** — 在支持 `⌘W` 关闭标签的环境中同样适用
- **Finder** — 当该应用将 `⌘W` 绑定为关闭窗口时，可关闭最前窗口

> TapBind 只负责发送快捷键。是否真的会关闭，取决于当前前台应用以及该应用里 `⌘W` 的含义（关标签还是关窗口）。

## 系统要求

- macOS（已在较新版本包括 Sequoia 上测试）
- **辅助功能（Accessibility）** 权限（系统设置 → 隐私与安全性 → 辅助功能）
- 支持多点触控的内建触控板或妙控鼠标

## 安装与构建

本仓库 **不提供预编译安装包**。`build/` 目录（含本地打的 `.zip`）在 [`.gitignore`](./.gitignore) 中，**不会**提交到 Git。请在本机用 **Xcode** 构建后使用。

> Homebrew 的 [`middleclick`](https://github.com/Homebrew/homebrew-cask/blob/master/Casks/m/middleclick.rb) 安装的是 **上游 MiddleClick**，不是 TapBind。

### 构建并运行（本机使用）

```sh
git clone https://github.com/gmch1/TapBind.git
cd TapBind
make run
```

`make run` 会构建未签名的 Debug 版 `TapBind.app` 并启动。产物路径：

```text
build/DerivedData/Build/Products/Debug/TapBind.app
```

若改了代码或删了 `.app`，但 `make build-debug` 提示无需构建，可强制重编：

```sh
make force-build
# 或：make clean-build && make build-debug
```

可选：复制到「应用程序」：

```sh
cp -R build/DerivedData/Build/Products/Debug/TapBind.app /Applications/
open /Applications/TapBind.app
```

按提示在 **系统设置 → 隐私与安全性 → 辅助功能** 中授权。

### 打包 zip 发给他人

在 `make build-debug` 或 `make run` 之后：

```sh
APP="build/DerivedData/Build/Products/Debug/TapBind.app"
ditto -c -k --keepParent "$APP" build/TapBind-test.zip
```

将 `build/TapBind-test.zip` 发给对方（聊天、邮件、Issue 附件等）。对方 **无需** clone 仓库，解压后执行：

```sh
unzip TapBind-test.zip
xattr -cr TapBind.app
open TapBind.app
```

每台 Mac 都要单独给该副本授予 **辅助功能**。Debug 包 **未签名**，首次打开可能需 `xattr -cr` 或 **右键 → 打开**。

**分享时注意：**

- 在 Apple Silicon 上构建一般为 **arm64**；Intel Mac 需在那台机器上自行构建。
- TapBind 的 bundle ID 为 `art.ginzburg.TapBind`，与 MiddleClick 的偏好和权限 **不通用**。

## 首次使用

1. 启动 **TapBind** — 菜单栏会出现图标（之后可用 ⌘ 拖动隐藏）。
2. 若弹出提示，请允许 **辅助功能**。
3. 在 Safari 或其他应用中试一下 **三指点击** 触控板。
4. 在菜单中按需调整：
   - **Also trigger on tap** — 除物理点击外，是否也响应多指轻点
   - **Advanced → 手指数** — 例如改为 4 指，减少与系统三指手势冲突
   - **Ignore focused app** — 对当前前台应用禁用 TapBind（配合三指拖移时忽略 Finder 很有用）
   - **Launch at login** — 登录时启动

若系统设置中开启了 **三指拖移** 或 **三指轻点（查询与数据检测器）**，请阅读 [three-finger-drag.md](./docs/three-finger-drag.md) — 使用 3 指模式时 TapBind 会提示可能冲突。

## 偏好设置（菜单栏与 `defaults`）

### 隐藏菜单栏图标

按住 **⌘** 将图标拖出菜单栏。应用在后台运行时再次打开 TapBind，可唤回菜单。

### 手指数量

默认：**3**（恰好 3 指）。示例 — 改为 4 指：

```sh
defaults write art.ginzburg.TapBind fingers 4
```

> 设为 **2** 指容易与普通双指滚动、点击冲突。

### 允许多于设定手指数

若有时会多一根手指误触触控板，可开启：

```sh
defaults write art.ginzburg.TapBind allowMoreFingers true
```

默认：`false`（必须严格匹配设定手指数）。

### 轻点灵敏度

**最大移动距离**（归一化 0–1，默认 `0.05`）：

```sh
defaults write art.ginzburg.TapBind maxDistanceDelta 0.03
```

**最大持续时间**（毫秒，默认 `300`）：

```sh
defaults write art.ginzburg.TapBind maxTimeDelta 150
```

## 故障排除

- [更新后辅助功能失效](./docs/troubleshooting.md#accessibility-permissions-not-working-after-an-update)
- [杀毒软件误报](./docs/troubleshooting.md#antivirus--cleanmymac-flags-tapbind-as-adware)
- [三指拖移与系统手势冲突](./docs/three-finger-drag.md)

## 致谢

TapBind 由 [本仓库](https://github.com/gmch1/TapBind) 维护。

项目衍生自 [MiddleClick](https://github.com/artginzburg/MiddleClick)，原作者 [Clément Beffa](https://clement.beffa.org/)，并曾由 [Alex Galonsky](https://github.com/galonsky)、[Carlos E. Hernandez](https://github.com/carlosh)、[Pascâl Hartmann](https://github.com/LoPablo)、[Arthur Ginzburg](https://github.com/artginzburg) 等参与维护。多点触控方案与大量底层代码来自原项目；**Command+W 快捷行为与 TapBind 品牌为本分支独有**。
