# 博客

同时开好几个 Agent 写代码的实用做法,以及 gtree 每个功能是怎么帮上忙的。

- [为什么 gtree 不用 Electron:24 MB 安装包,0.2 秒开窗](https://gtree.dobbylab.com/zh/blog/gtree-native-app-not-electron/) (2026-10-25) — gtree 用 Rust 写,界面由 Zed 编辑器的 GPU 渲染框架 GPUI 绘制,不带浏览器、不带 Node。这篇讲原生能换来什么,附实测数字和测法。
- [撤销 Claude Code 的改动:回到任意一轮,关掉的会话也行](https://gtree.dobbylab.com/zh/blog/undo-claude-code-changes/) (2026-10-22) — AI agent 三轮之前把东西改坏了?对比三种撤销办法:git、Claude Code 的 /rewind,以及 gtree 的「AI 每一轮」—— 任意一轮的文件都能恢复,新会话还记得上次做到哪。
- [两个 AI agent 改同一个文件:怎么让它们先商量、不互相覆盖](https://gtree.dobbylab.com/zh/blog/ai-agents-editing-same-file/) (2026-10-19) — 多开 Claude Code 或 Codex 时,两个 AI agent 改到同一个文件怎么提前发现?手动用 git 检查的命令,以及 gtree 怎么让 agent 先互相打招呼、商量谁先改。
- [Claude Code 在等你授权?怎么第一时间知道](https://gtree.dobbylab.com/zh/blog/claude-code-waiting-for-approval-notifications/) (2026-10-13) — Claude Code 一要授权就停下来干等。教你用 Notification hook 发系统通知,以及多开时怎么一屏看清哪个 Claude 在跑、哪个在等你。
- [Claude Code 多开:用 git worktree 同时跑多个 AI](https://gtree.dobbylab.com/zh/blog/run-multiple-claude-code-git-worktree/) (2026-10-10) — 想同时开好几个 Claude Code 改同一个仓库?给每个会话一个 git worktree 就不会互相覆盖。这里有能直接用的命令、常见的坑,以及怎么省掉这些重复操作。
