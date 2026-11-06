# Why gtree Isn't Electron: 24 MB, Window in 0.2 Seconds

> A native Rust + GPUI app with no bundled browser or Node: 24 MB download, window in about 0.2 s, ~100 MB idle memory. Measured numbers and how we got them.

Published: 2026-10-25 · DobbyLab · https://gtree.dobbylab.com/blog/gtree-native-app-not-electron/

gtree is a native desktop app, not an Electron app or a web view. It's written in Rust, its interface is drawn on the GPU with **GPUI** (the UI framework behind the Zed editor), and the package contains no browser engine and no Node runtime. The download is **24 MB**. On an Apple M4, the window appears in **about 0.2 seconds** (warm start), and gtree sits at **about 100 MB of memory** when idle. Below: why that matters when you run several AI coding agents, what's under the hood, and exactly how those numbers were measured.

![The gtree window: the sidebar with Inbox, History and a project's worktrees, and the start page of one worktree in the middle](/media/app/start-page-light.webp "One native window: no browser engine inside")

## Why should a tool for AI agents be lightweight?

When you have three or four agents working, each in [its own git worktree](/blog/run-multiple-claude-code-git-worktree/), your Mac is already busy: every agent runs builds, test suites and dev servers, and each worktree has its own `node_modules` or `target/`. The app that keeps an eye on all of them should take as little of that as possible.

That's the whole reason gtree is native. A desktop app built on Electron ships its own copy of Chromium and Node.js, and every window is a web page. That's a sensible trade for many apps. For a tool that stays open all day next to compilers and agents, we'd rather spend the memory and disk on your work.

## What is gtree built with?

- **Rust**, compiled to a single native arm64 binary.
- **GPUI** for the interface, the same framework the Zed editor uses. It renders with **Metal** on the GPU. There is no web view: not Electron, not Tauri, not a WKWebView. The app's Resources folder holds one icon file.
- **gitoxide** (a pure-Rust git implementation) for most reads, such as history and branches; some status and diff checks call git directly.
- **Your own `git`** for anything that writes: commit, push, pull, rebase. Your SSH keys, credentials and git hooks work exactly as they do in the terminal.
- **A built-in terminal** of our own (`gpui-term`): `alacritty_terminal` parses the terminal protocol, GPUI draws it. Inside it runs the real agent CLI, Claude Code or Codex, not a re-implementation.
- **Search** uses `git grep -F`, and the ⌘P file finder searches the file tree that's already in memory instead of scanning the disk again.

## How fast is it? The measured numbers

| What | Measured | How |
|---|---|---|
| Download (zip) | **23.6 MB** | Size of `gtree-0.3.14-macos-aarch64.zip` on the GitHub release |
| Installed app | **73 MB** | `du -sh` on the installed `.app`. Almost all of it is one executable; Resources is a 1.1 MB icon |
| Launch to window on screen | **162–206 ms**, median 176 ms (7 runs) | From spawning the process to the app's first on-screen window, polled every 2 ms. **Warm cache**, not a cold start after a reboot |
| Launch to repository loaded | **458–574 ms** (3 runs) | From spawning the process to the log line reporting 6 worktrees, 14 branches and 200 commits loaded |
| Memory when idle | **93–99 MB** | Activity Monitor's "Memory" (physical footprint), sampled every 2 seconds for 20 seconds, starting 30 seconds after launch |

**Test setup:** Apple M4 (10 cores), 24 GB RAM, macOS 15.3.1, the released gtree 0.3.14. The repository was a local clone of gtree's own repo (366 commits, 474 files) plus 5 extra worktrees, each with one commit and one uncommitted change, so the sidebar showed 1 project and 6 lines. We used a temporary home folder with telemetry off, so no real projects or settings were involved.

These are measurements on one machine, not a benchmark suite. Your numbers will vary with the size of your repositories and how many projects you keep open.

## Does gtree slow down on big repositories?

Being native is only part of it. A few rules in the codebase do the rest:

- **Long lists only draw what you can see.** Commits, branches, diff lines, files and past conversations all use virtual scrolling, so a list with thousands of rows only draws the few dozen that are on screen.
- **Heavy git work runs in the background.** Loading history, computing diffs and checking which branches are merged happen off the main thread, so the window keeps responding while they run.

## Does gtree upload my code?

No. gtree never uploads your code. Local features are free and need no account. Your agents talk to their own providers exactly as they would without gtree; gtree reads their status through hooks on your machine.

On permissions, gtree asks for notifications, and that's optional. It doesn't need Full Disk Access, Accessibility or Screen Recording. Updates are downloaded from our releases and their SHA-256 checksum is verified before the app replaces itself.

## What are the limits?

- **macOS on Apple Silicon only** for now. The installer is arm64.
- **Not open source** at the moment.
- **This post covers launch and idle.** We'll publish numbers for several agents busy at once in a follow-up.

## FAQ

### Is gtree built on Electron or Tauri?

Neither. It's a native Rust app whose interface is drawn by GPUI on the GPU (Metal). There's no web view inside.

### How big is gtree?

The download is 23.6 MB and the installed app takes 73 MB on disk, nearly all of it a single native binary.

### How fast does gtree start?

On an Apple M4 with a warm cache, the window appears in 162–206 ms (median 176 ms), and a repository with 6 worktrees finishes loading in about half a second.

### How much memory does gtree use?

About 93–99 MB when idle on our test machine (Activity Monitor's figure), with one project and six worktrees open.

### Which agents does it work with?

Claude Code and Codex. Claude Code was supported first and has the deepest integration.

### Does it work on Intel Macs, Windows or Linux?

Not yet. The current release is for macOS on Apple Silicon.

gtree is free for local use, needs no account, and never uploads your code. [Download gtree](https://gtree.dobbylab.com/) and see how it feels next to the agents you already run.
