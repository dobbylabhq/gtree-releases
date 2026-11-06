# 隐私政策

最后更新: 2026-10-16

## 概要

gtree 是一款完全在你的电脑上运行的桌面应用,没有 gtree 账号,也不需要登录。**gtree 从不上传你的源代码**,也不会把文件名、路径、仓库名、git 配置、Claude Code 或 Codex 的对话发给我们。应用发给 DobbyLab 的唯一内容,是附在常规「检查更新」请求上的匿名使用统计,点一下就能关掉。

本政策适用于 gtree 应用、官网 https://gtree.dobbylab.com 和下载服务器 https://gtree-dl.dobbylab.com。它们由 **DobbyLab** 运营 —— 这是个人开发者 tzyito 的名号,不是注册公司。

## 应用会发送什么

gtree 启动 10 秒后检查一次更新,之后每 6 小时检查一次(只有正式版会这样做)。检查更新就是从 `gtree-dl.dobbylab.com` 取一个很小的版本清单文件;如果连不上,会直接从 GitHub 取同一个文件,这时不带任何统计信息。

匿名使用统计打开时,检查更新的请求会额外带上四项:

- **随机设备 ID**:第一次使用时在你的 Mac 上随机生成的 32 位十六进制串,存在 `~/.gtree/device-id`。它不是从硬件、你的名字或 Apple ID 推出来的。
- **gtree 版本号**(例如 `0.4.1`)
- **CPU 架构**(`aarch64` 或 `x86_64`)
- **macOS 版本**(例如 `15.3`)

我们只用这些数字来统计每天有多少台设备在用、新增了多少台、各版本的分布。除此之外什么都不带。

**先告知,后上报。** 正式版第一次启动时,侧栏会出现一张「匿名使用统计」卡片。在这张卡片显示之前,不会上报任何统计。

下载更新时同样经过 `gtree-dl.dobbylab.com`,这会让当天这个版本的下载计数加一,另按国家再计一份。

## 应用不会发送什么

gtree 从不向 DobbyLab 发送:

- 源代码、diff 或文件内容
- 文件名、文件夹路径、仓库名或远端地址
- git 配置、用户名、邮箱或提交历史
- 你对 Claude 的提问、Claude 的回答或会话记录
- 崩溃报告(gtree 没有崩溃上报功能)

## 怎么关闭统计

以下任一方式都可以。关掉后照常检查更新,只是不再带上面那四项。

- 在首次启动的卡片上点 **关闭统计**
- 打开 **设置**(⌘,),关掉 **匿名使用统计**
- 新建一个空文件 `~/.gtree/telemetry-off`
- 用环境变量 `GTREE_NO_TELEMETRY=1` 启动 gtree

如果想连检查更新也一起停掉(也就是完全不和我们的服务器通信),用 `GTREE_NO_UPDATE=1` 启动 gtree。这样就需要你手动更新了。

## 只存在你 Mac 上的数据

gtree 的工作数据都存在本地,不会发给 DobbyLab。

- **`~/.gtree/`**:设置、设备 ID,以及一个本地数据库(`gtree.db`)。数据库里记着你的项目列表;如果你配合 Claude Code 使用,还会记下 Claude 每一轮的记录(你的提问、Claude 最后的总结、改动了哪些文件),方便后来的会话接着之前的进度干。
- **各仓库的 git 目录里**:Claude 会话的状态文件(`.git/gtree/`)和 `refs/gtree/agent/` 下的检查点提交。gtree 不会把这些 ref 推送到任何地方。
- **Claude Code 集成**:安装后,gtree 会在 `~/.claude/settings.json` 里加上自己的 hook 条目,放三个小脚本(默认在 `~/.claude/gtree/`),并给 Claude Code 注册一个本地 MCP 服务。hook 只把事件交给你 Mac 上的 gtree,不连接任何服务器。gtree 只增删自己的条目,绝不碰你自己或其他工具注册的条目。
- **Codex 集成**:连上 Codex 时,gtree 会在 `~/.codex/hooks.json` 里加上自己的 hook 条目,在 `~/.codex/gtree/` 放三个小脚本,通过 Codex 自己的命令注册一个本地 MCP 服务,并在 `~/.codex/config.toml` 里把这几条 hook 标成已信任(省得你在 Codex 里逐条批准)。在 gtree 里打开 Codex 前,还会替你把这个仓库写成 Codex 的受信任项目(`config.toml` 里的 `[projects."<仓库路径>"]`,已有这一项的不动)。和 Claude Code 一样,hook 只把事件交给你 Mac 上的 gtree,不连接任何服务器;gtree 只增删自己的条目,不碰你自己或其他工具的。「历史对话」搜索和回放 Codex 会话时,读的是本机 `~/.codex/sessions/` 下的记录。
- **通知**通过 Mac 的通知中心显示,发之前会先征求你的同意。

用 **设置 → 删除 gtree** 可以删掉 Claude Code 和 Codex 集成、各仓库里的 gtree 数据和 `~/.gtree/`;也可以选择保留数据。写进 Codex 的项目信任会保留,不需要的话可以在 `~/.codex/config.toml` 里删掉。

## AI 功能、Claude Code 与 Codex

gtree 没有自带的 AI 模型,也不直接调用任何 AI 服务。它只是在你 Mac 的终端里启动**你自己的** `claude` 或 `codex` 命令行工具。你对 Claude 说的话、Claude 读到的代码,都由 Claude Code 按你和 Anthropic 之间的条款处理;用 Codex 时同理,由 Codex 按你和 OpenAI 之间的条款处理。这些都不经过 DobbyLab。

为了让多个会话互相知道彼此,gtree 会把你 Mac 上的一部分信息交给你的 Claude Code 或 Codex 会话:别的会话正在做什么、改了哪些文件、之前几轮的提问和总结,有时也包括你其他项目的这些信息。这些内容会成为那段对话的一部分,和你对 AI 说的其他话一样,按你与 Anthropic(Claude Code)或 OpenAI(Codex)之间的条款处理。它们不会发给 DobbyLab。

## git 操作

fetch、pull、push 等操作,gtree 调用的是你系统里的 `git`。仓库打开期间,gtree 会在后台大约每 3 分钟 `git fetch` 一次。这些连接用你自己的凭证,从你的 Mac 直接连到你配置的远端(GitHub、GitLab、自建服务器等),DobbyLab 看不到。

## 队友(默认关闭)

「队友」让你和队友互相看到还在写的代码。它**默认关闭**,按仓库单独开启:只有最近有别人提交过的仓库才会在侧栏出现「队友」一节,你点「开启」、读完说明再点「开始同步」才会生效。开关记在这个仓库的 git 配置里(`gtree.shareLive`)。

开启后:

- **同步什么**:这个仓库里还没交给团队的代码 —— 没提交的改动、新建的文件、还没推送的提交 —— 连同分支名,会推送到**你们团队自己的 git 远端**上一个不显示为分支的位置(`refs/gtree/`)。被 `.gitignore` 忽略的文件、1MB 以上的未跟踪文件和 AI 临时工作区不同步。gtree 会在你改完后自动推送、并定期拉取队友的。
- **谁看得到**:对这个远端有读权限的人(以及托管它的平台,如 GitHub、GitLab)都能看到同步上去的代码内容。DobbyLab 不经手,也没有自己的服务器参与。
- **身份**:为了防止有人冒充,gtree 会在你的 Mac 上为你的 git 邮箱生成一把钥匙(私钥存在 `~/.gtree/team-keys/`,只有你本人可读,不会离开这台电脑),并把公钥连同你的名字和邮箱推送到同一个远端。同步的内容都带你的签名。
- **留言**:你的 AI 给队友的留言,同样经这个远端传递,**端到端加密**,只有收件人能解开;仓库里的其他人只能看到有一条发给谁的留言,看不到内容。新的留言要等收件人本人看过、确认后,才会交给他的 AI;对你的 AI 先前提问的回复,会直接回到发问的那个 AI。交给 AI 之后,按收件人与 AI 服务商之间的条款处理。
- **关闭**:随时可以关。关闭后不再同步,已推送的内容会从远端撤回;队友已经拉取过的副本无法收回。

## 官网

- 官网是静态网站,托管在 **GitHub Pages**。
- 用 **Cloudflare Web Analytics** 统计访问量,不使用 cookie,只在 `gtree.dobbylab.com` 上加载。
- 页面打开时会向 `gtree-dl.dobbylab.com` 查询最新版本号,这会让当天的页面打开计数(按国家)加一。
- 官网会在浏览器的 localStorage 里记三样东西:深浅色主题、语言选择、是否已加入早鸟名单。这些只留在你的浏览器里,不会发给我们。
- 官网自己不设置任何 cookie。

## 下载服务器

`gtree-dl.dobbylab.com` 是一个 Cloudflare Worker,负责转发我们公开的 GitHub Release 里的安装包和安装脚本。每来一个请求,就按类型(下载、安装脚本、检查版本、页面打开)、版本和国家把**当天的计数**加一。

- 国家是 Cloudflare 根据 IP 地址判断的两位代码。**我们不保存 IP 地址。**
- 计数按天汇总,不保留单次下载的记录。
- 按设备存的数据只有两样,都来自上文的检查更新:「每台设备每天一行」(设备 ID、版本、CPU 类型、macOS 版本和国家),以及每台设备一行、记它第一次出现的日期,用来统计新增设备。

## 团队版早鸟名单

在官网加入团队版早鸟名单时,我们会保存:

- 你的邮箱
- 你选的团队规模(可不选)
- 报名日期
- 国家(Cloudflare 根据 IP 判断;IP 本身不保存)

邮箱只用来通知你团队版上线,不会给第三方。没有任何网页或 API 能读取这份名单,只有运营者本人能导出。同一个邮箱重复报名不会多存一条。

## 第三方服务

| 服务 | 在 gtree 里做什么 | 能接触到什么 |
|---|---|---|
| Cloudflare | 运行下载服务器及其数据库(D1)、Web Analytics、DNS,转发发往 `support@dobbylab.com` 的邮件 | 发往 `gtree-dl.dobbylab.com` 的请求、官网访问(Web Analytics)、早鸟名单、发给客服的邮件 |
| GitHub | 托管官网(GitHub Pages)和发布文件 | 官网访问;直接回退到 GitHub 的请求 |
| Anthropic | 提供 Claude Code(由你自己安装和登录) | 你在 Claude Code 里分享的内容,按 Anthropic 的条款处理;DobbyLab 不参与 |
| OpenAI | 提供 Codex(由你自己安装和登录) | 你在 Codex 里分享的内容,按 OpenAI 的条款处理;DobbyLab 不参与 |

这些服务各自按自己的隐私政策处理数据。

## 数据保存多久

- **Cloudflare D1 里按天汇总的计数和按设备存的数据**:目前没有自动删除,会一直保留到我们手动删除。
- **早鸟名单**:保留到团队版上线、不再需要为止,或者你要求删除为止。
- **Cloudflare Web Analytics、Cloudflare 基础设施日志、GitHub Pages 日志**:按 Cloudflare 和 GitHub 各自的政策保存。
- **你 Mac 上的数据**:保留到你自己删除或卸载 gtree 为止。

## 你的选择和权利

- **统计**:随时可以按上面的方法关掉。
- **早鸟名单**:用报名时的邮箱发信到 support@dobbylab.com,我们会把它删掉。
- **设备 ID**:这个 ID 是随机的、和你本人对不上,所以我们自己没法找出「你的」数据。如果想删除它的记录,把 `~/.gtree/device-id` 的内容发给我们即可。删掉这个文件后,gtree 下次会生成一个新的 ID。

## 儿童

gtree 是面向开发者的工具,不面向 13 岁以下的儿童,我们也不会有意收集儿童的个人信息。如果你认为有儿童加入了早鸟名单,请联系我们,我们会删除。

## 政策变更

如果 gtree 收集的内容有变化,我们会在变更发布之前更新本页和顶部的日期。应用里的数据收集,今后也同样坚持先告知、后上报。

## 联系我们

- 邮箱:support@dobbylab.com
- X:[@dobbylabhq](https://x.com/dobbylabhq)
- 官网:https://gtree.dobbylab.com
