# Claude Code 多开:用 git worktree 同时跑多个 AI

> 想同时开好几个 Claude Code 改同一个仓库?给每个会话一个 git worktree 就不会互相覆盖。这里有能直接用的命令、常见的坑,以及怎么省掉这些重复操作。

Published: 2026-10-10 · DobbyLab · https://gtree.dobbylab.com/zh/blog/run-multiple-claude-code-git-worktree/

想在同一个仓库里同时开好几个 Claude Code,最稳的做法是**每个会话一个 git worktree**。worktree 是同一个仓库的另一份工作目录,签出自己的分支,但和主目录共用同一份 `.git` 历史。用 `git worktree add ../myapp-fix-login -b fix-login` 建一个,进去跑 `claude`,每个任务重复一遍,几个 AI 就能各改各的、各跑各的测试,谁也不会覆盖谁的文件。

原理就这么简单。下面讲实际要敲的命令、第一周最容易踩的坑,以及 gtree 怎么把这些重复操作省掉。

![gtree 中 export-pdf 这条线的开始页:「1 个提交还没推送 [推送]」「MR #42 未合并 [打开 MR]」「比 main 落后 4 个提交 [变基到 main]」;左侧侧栏列着 nimbus-notes 的各条线,每条行尾一个状态标记](/media/app/start-page-zh-light.webp "在侧栏选一条线,开始页告诉你下一步做什么")

## 为什么不直接在同一个目录里开两个 Claude Code?

能开,只问问题不改代码的话也没事。可两个会话一旦都开始改文件,就是在共用一个没有任何隔离的工作目录:

- 会话 A 刚改完 `auth.ts`,会话 B 拿着之前读到的内容又改了一遍;
- A 改到一半编译不过,B 跑的每次测试都跟着失败,B 却不知道原因;
- 到提交的时候,两个任务的改动搅在同一份 diff 里,拆都拆不开。

光靠分支解决不了,因为一个目录同一时间只能签出一个分支。worktree 可以:每个 worktree 都是一个真实的目录,有自己的分支、自己的未提交改动、自己的编译产物,而提交、分支、远程仓库全部共用。

## 怎么用 git worktree 给 Claude Code 分开工作区?

在主目录里执行:

```bash
# 1. 在仓库旁边建一个 worktree,同时新建分支
git worktree add ../myapp-fix-login -b fix-login

# 2. 进去启动 Claude Code
cd ../myapp-fix-login
claude
```

再开一个终端,给下一个任务也来一遍:

```bash
git worktree add ../myapp-search -b search-box
cd ../myapp-search
claude
```

常用的几条命令:

| 命令 | 作用 |
|---|---|
| `git worktree list` | 列出所有 worktree 的路径、提交和分支 |
| `git worktree add <路径> -b <新分支>` | 新目录 + 新分支 |
| `git worktree add <路径> <已有分支>` | 新目录,签出一个已有的分支 |
| `git worktree remove <路径>` | 删掉这个 worktree(有未提交改动时会拒绝,加 `--force` 强删) |
| `git worktree prune` | 清理已经被手动删掉目录的 worktree 记录 |

任务做完,照常合并或者提 MR / PR,再把 worktree 删掉。

## git worktree 有哪些坑?

大部分麻烦都来自一点:新 worktree 里**只有被 git 跟踪的文件**。

1. **依赖不会跟过去。** `node_modules`、`target/`、`.venv` 这些都在 `.gitignore` 里,每个 worktree 都得自己装一遍、编一遍。磁盘空间和首次编译时间要算进去。
2. **本地配置也不会跟过去。** `.env` 之类被忽略的配置文件,要手动复制或软链到每个 worktree。
3. **一个分支只能在一个 worktree 里签出。** `git worktree add` 报「分支已经被签出」时,换个新分支名就行。
4. **端口会冲突。** 两个 worktree 各起一个 dev server,默认端口会撞,得改掉其中一个。
5. **目录越堆越多。** 直接 `rm -rf` 删目录的话,git 还记着它,要跑一次 `git worktree prune`。

都不是大问题,只是每次都得记着。

## 真正的麻烦:五个终端,你盯不过来

环境搭好以后,新的问题才出现。五个 agent 开在五个终端标签里,意味着:

- 哪个在**等你授权**,得一个个标签翻过去才知道;
- 哪个已经**做完了**、该你验收,也不知道;
- 哪个 worktree 在哪个分支、离 `main` 差多少,慢慢就记不清了;
- 两个 agent 可能在不同 worktree 里**改同一个文件**,要到合并时才发现。

tmux 这类工具能把窗口排整齐,但它不知道窗口里的 agent 在干什么。gtree 补的就是这一层。

## gtree 怎么管多个 Claude Code

[gtree](https://gtree.dobbylab.com/zh/) 是一个围绕 worktree 设计的原生桌面应用,现在支持 Claude Code 和 Codex(最先支持、集成最深的是 Claude Code)。打开仓库,所有 worktree 都会出现在侧栏的项目下面,包括你在命令行里建的。点一条,就进到它的主页:开着会话就是对话,没有会话就是这条线的**开始页**,告诉你下一步该做什么。

**建 worktree:** 在侧栏右键任意一条线,选「新建 worktree…」,输入分支名。gtree 替你执行 `git worktree add`,新目录放在仓库旁边,命名为「<仓库名>-<分支名>」。「删除 worktree…」在同一个右键菜单里,会先让你确认;分支合并过的线,开始页直接给出「删除 worktree」按钮。

**在里面跑 agent:** 在开始页点「新开 Claude Code」,或者按 **⌘T**(装了 Codex 的话可以选用哪个)。gtree 的内嵌终端里跑的就是真正的 agent CLI,和你在 iTerm 里用的 Claude Code、Codex 完全一样:`/` 命令、plan mode、授权确认、MCP 都在。同一个 worktree 也可以开好几个会话。只是点进来看看的话,不会自动起会话。

**一眼看清每个会话:** 在设置里连上 Claude Code(或 Codex)之后,侧栏每条线的行尾只放一个状态标记:紫色转圈 = 它的 agent 在干活,红色铃铛一闪一闪 = 在等你。悬停能看详情。不用读字,找红铃铛就行。[下一篇](/zh/blog/claude-code-waiting-for-approval-notifications/)会细讲。

**每条分支的状态:** 开始页只列要处理的事,每种状况一行,各带一个按钮:

| 开始页上写的 | 按钮 |
|---|---|
| 这条分支已经合并了 | 删除 worktree / 换一条新分支 |
| N 个文件别处也在改 | 看是哪些 |
| N 个文件没提交 | 看改动 |
| 远端有 N 个新提交 | 拉取 |
| N 个提交还没推送 | 推送 |
| 变基后和远端的这条分支不一致了 | 推送(覆盖远端) |
| MR #N 未合并 / 还没有 MR | 打开 MR / 创建 MR |
| 比 main 落后 N 个提交 | 变基到 main |

没有要处理的事时,开始页会显示「这条线是最新的,没有要处理的事」。侧栏里每条分支后面还有 MR 状态:MR 开着是一个 MR 图标,合并后变成浅色的合并图标。数据来自你本机已经登录的 `glab` 或 `gh`,GitHub、GitLab(包括自建)都行。完整的 Git 菜单(提交、拉取、推送、变基、切分支等)在右键菜单里,所有写操作走你自己机器上的 git,SSH key 和 hook 照常生效。所有分支的全貌在「提交历史」(⌘3)里:每条分支一条泳道,标着它签出在哪个 worktree。

![「提交历史」(⌘3):最上面是 AI 检查点,下面每条分支一条彩色泳道,比如 feat/export-pdf、refactor/api-retry、fix/login、feat/search](/media/app/history-graph-ai-turns-zh-light.webp "「提交历史」(⌘3):所有分支画在一张图里,每条分支一条泳道")

**看改了什么:** 开始页的「看改动」直接在中间打开 diff,左边是改了的文件,右边是内容。合并前想审整条分支,「提交历史 › 对比」默认就是「主分支 → 当前 worktree」,不用敲 `git diff`。

**撞车提醒:** 两个 worktree 改了同一个文件,(那条线上没有会话状态图标时)侧栏行尾会出现琥珀色 △;开始页一定会写明有几个文件别处也在改,点「看是哪些」列出来;两边都还没提交的,还会出现在「待处理」的「也许要留意」里。同一个 worktree 里做得更多:两个 agent 要改同一个文件时,会先知道对方的存在,还能互相留话、商量谁先改。具体怎么回事见[两个 AI agent 改同一个文件](/zh/blog/ai-agents-editing-same-file/)。

### 手动 vs gtree

| | 终端 + git | gtree |
|---|---|---|
| 建 worktree | `git worktree add ../x -b x` | 右键 →「新建 worktree…」 |
| 启动 agent | 新标签里 `cd` + `claude` | 开始页 → 新开会话(⌘T) |
| 谁在等你? | 挨个标签翻 | 侧栏铃铛 + 系统通知 |
| 分支状态 | 每个目录跑 `git status` / `git log` | 开始页 + 侧栏行尾标记 |
| 两边改了同一个文件 | 合并时才知道 | 两边都改了就标出来 |

## 一套能撑到五个会话的工作流

1. 主目录始终签出 `main`(或你的默认分支),不让 AI 在这里干活;
2. 一个任务 = 一个 worktree = 一个分支,分支名照任务起;
3. 给每个 agent 的提示词写清它负责哪些文件、哪块功能;
4. 合并前把分支和 `main` 对比一遍,合完删掉 worktree;
5. 勤合并。两条分支活得越久,差得越远。

## 常见问题

### 最多能同时开几个 Claude Code?

git 本身没有上限。实际受限于你的注意力、机器性能(每个 worktree 可能都要装依赖、编译)和你所用套餐的用量额度。

### git worktree 和分支有什么区别?

分支是一串提交;worktree 是签出了某个分支的一个目录。一个目录同一时间只能签出一个分支,worktree 让你有好几个目录,各自签出自己的分支,共用同一份历史。

### worktree 占磁盘多吗?

git 历史是共用的,一个 worktree 只多占签出文件的大小,再加上你在里面装的依赖和编译产物。大头通常是 `node_modules` 这类依赖目录。

### 不用 gtree 能用 worktree 跑 Claude Code 吗?

当然能,上面的命令只需要 git 和终端。gtree 省掉的是那些琐事:建 worktree、找到在等你的那个会话、发现两边改了同一个文件。

### gtree 会替代 Claude Code 吗?

不会。gtree 在自己的终端里跑真正的 agent CLI(Claude Code 或 Codex),再读出它的状态。你的 Claude Code 配置、设置和订阅都原样不动。

gtree 本地功能免费、不用注册;gtree 不上传你的代码。[在这里下载](https://gtree.dobbylab.com/zh/),打开你正在做的仓库,已有的 worktree 都会出现在侧栏里。

*本文已按 gtree 0.3.14 更新(2026 年 10 月)。*
