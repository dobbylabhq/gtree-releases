# Blog

Practical guides for coding with several AI agents at once, and how each gtree feature helps.

- [Why gtree Isn't Electron: 24 MB, Window in 0.2 Seconds](https://gtree.dobbylab.com/blog/gtree-native-app-not-electron/) (2026-10-25) — A native Rust + GPUI app with no bundled browser or Node: 24 MB download, window in about 0.2 s, ~100 MB idle memory. Measured numbers and how we got them.
- [How to Undo Claude Code Changes, Even After the Session Ends](https://gtree.dobbylab.com/blog/undo-claude-code-changes/) (2026-10-22) — Undo AI coding changes three ways: git, Claude Code's /rewind, and gtree's per-turn checkpoints, which restore any turn's files even after the session is closed.
- [Two AI Agents, One File: Stop Them Overwriting Each Other](https://gtree.dobbylab.com/blog/ai-agents-editing-same-file/) (2026-10-19) — Two AI agents editing the same file? Spot overlaps with plain git, or let the agents message each other and agree who goes first. Works with Claude Code and Codex.
- [How to Know When Claude Code Is Waiting for Your Approval](https://gtree.dobbylab.com/blog/claude-code-waiting-for-approval-notifications/) (2026-10-13) — Claude Code stops whenever it needs permission. Get notified with a Notification hook, and see which of your sessions is waiting on one screen.
- [How to Run Multiple Claude Code Sessions with Git Worktree](https://gtree.dobbylab.com/blog/run-multiple-claude-code-git-worktree/) (2026-10-10) — Give each Claude Code session its own git worktree so parallel AIs never share a folder. The exact commands, the gotchas, and how to skip the busywork.
