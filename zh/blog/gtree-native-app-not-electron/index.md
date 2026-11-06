# 为什么 gtree 不用 Electron:24 MB 安装包,0.2 秒开窗

> gtree 用 Rust 写,界面由 Zed 编辑器的 GPU 渲染框架 GPUI 绘制,不带浏览器、不带 Node。这篇讲原生能换来什么,附实测数字和测法。

Published: 2026-10-25 · DobbyLab · https://gtree.dobbylab.com/zh/blog/gtree-native-app-not-electron/

gtree 是一个原生桌面应用,不是 Electron,也不是套了网页的壳。它用 Rust 写,界面由 **GPUI**(Zed 编辑器用的 UI 框架)在 GPU 上绘制,安装包里没有浏览器引擎、没有 Node。安装包 **24 MB**;在 Apple M4 上实测,**约 0.2 秒**出窗口(热启动),空闲时内存**约 100 MB**。下面讲同时开着几个 AI 编程 agent 时这为什么重要、底下用了什么,以及这些数字具体是怎么测的。

![gtree 窗口:侧栏里是待处理、提交历史和一个项目的各条线,中间是某条线的开始页](/media/app/start-page-zh-light.webp "一个原生窗口,里面没有浏览器引擎")

## 管 AI agent 的工具,为什么要轻?

三四个 agent 同时干活、[每个在自己的 git worktree 里](/zh/blog/run-multiple-claude-code-git-worktree/)的时候,你的 Mac 本来就很忙:每个 agent 都在编译、跑测试、起 dev server,每个 worktree 还各有一份 `node_modules` 或 `target/`。盯着它们的那个应用,应该尽量少占资源。

gtree 做成原生的,原因就这一条。基于 Electron 的桌面应用会自带一份 Chromium 和 Node.js,每个窗口都是一个网页。对很多应用来说这是合理的取舍;但一个整天开着、和编译器、agent 抢机器的工具,我们宁愿把内存和磁盘留给你的活。

## gtree 用什么做的?

- **Rust**,编译成单个原生 arm64 可执行文件。
- 界面用 **GPUI**,和 Zed 编辑器同一套框架,通过 **Metal** 在 GPU 上渲染。没有 web view:不是 Electron,不是 Tauri,也不是 WKWebView。应用的 Resources 目录里只有一个图标文件。
- 大部分读操作(历史、分支等)用 **gitoxide**,纯 Rust 实现的 git;一部分状态和 diff 检查直接调用 git。
- 写操作(提交、推送、拉取、变基)调用**你机器上的 `git`**,所以 SSH key、凭据和 git hook 和在终端里一样生效。
- **内嵌终端**是自己写的(`gpui-term`):`alacritty_terminal` 解析终端协议,GPUI 负责绘制。里面跑的是真正的 agent CLI(Claude Code 或 Codex),不是仿制品。
- **搜索**走 `git grep -F`;⌘P 找文件直接搜已经在内存里的文件树,不再扫一遍磁盘。

## 到底多快?实测数字

| 项目 | 实测 | 测法 |
|---|---|---|
| 安装包(zip) | **23.6 MB** | GitHub Release 上 `gtree-0.3.14-macos-aarch64.zip` 的大小 |
| 装好后的应用 | **73 MB** | 对装好的 `.app` 跑 `du -sh`。几乎全是一个可执行文件;Resources 只有 1.1 MB 的图标 |
| 启动到窗口出现 | **162–206 ms**,中位数 176 ms(7 次) | 从启动进程开始,每 2 ms 查一次,直到它的第一个窗口出现在屏幕上。**热缓存**,不是重启电脑后的冷启动 |
| 启动到仓库载入完 | **458–574 ms**(3 次) | 从启动进程到日志里出现「6 个 worktree、14 个分支、200 个提交载入完成」那一行 |
| 空闲内存 | **93–99 MB** | 活动监视器的「内存」一列(物理内存占用)。启动 30 秒后开始,每 2 秒采一次,共 20 秒 |

**测试环境**:Apple M4(10 核),24 GB 内存,macOS 15.3.1,gtree 0.3.14 正式版。仓库是 gtree 自己仓库的本地克隆(366 个提交、474 个文件),另加 5 个 worktree,每个有 1 个提交和 1 处未提交改动,侧栏里是 1 个项目、6 条线。用的是临时的用户目录、关掉了统计,没有碰真实的项目和设置。

这是一台机器上的实测,不是跑分。你的数字会随仓库大小、开着的项目数量而不同。

## 仓库很大时会不会卡?

原生只是一部分,另外几条是代码里的硬规矩:

- **长列表只画看得见的那几行。** 提交、分支、diff 行、文件、历史对话都是虚拟滚动,列表有几千行,也只画屏幕上那几十行。
- **重的 git 操作放后台。** 读历史、算 diff、判断哪些分支已合并,都不在主线程上跑,跑的时候窗口照样能点。

## gtree 会上传我的代码吗?

不会。gtree 不上传你的代码。本地功能免费,不用注册。你的 agent 照常连它自己的服务商,和不用 gtree 时一样;gtree 只是通过你本机上的 hook 读它们的状态。

权限方面,gtree 只请求通知权限,而且可以不给;不需要完全磁盘访问、辅助功能或屏幕录制。自动更新从我们的发布页下载,下载后先核对 SHA-256 校验和,对得上才替换应用。

## 有哪些限制?

- 目前**只支持 Apple Silicon 的 macOS**,安装包是 arm64。
- 暂**不开源**。
- **这篇只讲启动和静止。** 「好几个 agent 同时在忙」时的数字,会在后续文章里公布。

## 常见问题

### gtree 是用 Electron 或 Tauri 做的吗?

都不是。它是原生 Rust 应用,界面由 GPUI 在 GPU(Metal)上绘制,里面没有 web view。

### gtree 有多大?

安装包 23.6 MB,装好后占 73 MB 磁盘,几乎全是一个原生可执行文件。

### gtree 启动多快?

在 Apple M4 上、热缓存的情况下,162–206 ms 出窗口(中位数 176 ms),有 6 个 worktree 的仓库大约半秒载入完。

### gtree 占多少内存?

在我们的测试机上,开着 1 个项目、6 个 worktree,空闲时约 93–99 MB(活动监视器的读数)。

### 支持哪些 agent?

现在支持 Claude Code 和 Codex。最先支持、集成最深的是 Claude Code。

### Intel Mac、Windows、Linux 能用吗?

暂时不能,当前版本只支持 Apple Silicon 的 macOS。

gtree 本地功能免费、不用注册,gtree 不上传你的代码。[下载 gtree](https://gtree.dobbylab.com/zh/),放在你正在跑的 agent 旁边试试。
