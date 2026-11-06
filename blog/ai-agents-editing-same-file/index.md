# Two AI Agents, One File: Stop Them Overwriting Each Other

> Two AI agents editing the same file? Spot overlaps with plain git, or let the agents message each other and agree who goes first. Works with Claude Code and Codex.

Published: 2026-10-19 · DobbyLab · https://gtree.dobbylab.com/blog/ai-agents-editing-same-file/

To stop two AI agents overwriting each other, give each its own git worktree and catch overlapping files before you merge, or, if they share a folder, make sure each knows what the other is doing before it edits. What goes wrong depends on where they work. In **separate git worktrees** nothing is overwritten, but you get a merge conflict later, so the fix is to spot the overlap early. In the **same folder** one agent can write straight over the other's half-finished work, so each needs to know what the other is doing before it edits. You can check both by hand with git. gtree checks them continuously, and in the same folder it goes one step further: the agents are told about each other and can message each other to agree who goes first.

![In the sidebar the dark-mode worktree ends with an amber △, and its start page says 1 file is also being changed elsewhere, with a See which button](/media/app/start-page-overlap-light.webp "Two worktrees changed the same file: the sidebar marks it and the start page lists it")

## What actually happens when two agents touch the same file?

There are two different situations, and they need different answers.

**Different worktrees.** Each agent has [its own working folder and branch](/blog/run-multiple-claude-code-git-worktree/), so neither can see the other's edits. Both happily change `src/auth.ts`, both pass their tests, and the conflict appears when you merge the second branch. If both reworked the same function, you're now resolving it by hand, often without remembering why each side did what it did.

**The same folder.** Two sessions share one working directory with no isolation. Claude Code already protects against the crudest failure: it refuses to apply an edit if the file changed since it last read it, so it won't silently write back stale content. The real risk is subtler. Agent B re-reads the file, sees agent A's fresh changes, and edits right over them without knowing they were A's work in progress. A also finds its half-finished change breaking B's build, or the other way round.

## How do you prevent conflicts between parallel AI agents?

Some habits help no matter what tools you use:

1. **Split work by area, not by step.** "Search UI" and "login rate limiting" rarely collide. "Refactor auth" and "add OAuth" almost certainly will.
2. **Say who owns what.** Name the files or directories each agent is responsible for in its prompt, and which ones it shouldn't touch.
3. **Give each agent its own worktree.** It turns silent overwrites into visible merge conflicts, which are much easier to deal with.
4. **Merge small and often.** A branch that lives for an hour rarely conflicts; one that lives for a week usually does.

## How to check for overlapping changes with git

**Uncommitted changes across worktrees.** This prints every file that has uncommitted changes in more than one worktree. It's a quick sketch that assumes paths without spaces:

```bash
git worktree list --porcelain | awk '/^worktree /{print $2}' |
while read -r wt; do
  git -C "$wt" status --porcelain | awk -v wt="$wt" '{print $NF, wt}'
done | sort | awk '
  { n[$1]++; w[$1] = w[$1] " " $2 }
  END { for (f in n) if (n[f] > 1) print f ":" w[f] }'
```

**Committed changes on two branches.** List what each branch changed since it split from `main`, then compare:

```bash
git diff --name-only main...fix-login
git diff --name-only main...search-box
```

**Will they actually conflict?** With Git 2.38 or newer, `merge-tree` performs the merge in memory without touching your working folder:

```bash
git merge-tree --write-tree fix-login search-box
```

It exits with status 0 if the branches merge cleanly. If they conflict, it exits with 1 and lists the conflicting files.

These commands work, but you have to remember to run them, and the uncommitted case is exactly the one that changes minute by minute while agents work. None of them helps with two agents in the same folder.

## How do two agents in the same folder agree who goes first?

This is the case git can't see at all, and the one gtree handles most closely. Once you connect Claude Code or Codex, gtree keeps track of which session edited which file. Here's what happens when two agents in one folder reach for the same file:

1. **Agent A edits `src/auth.ts`.** gtree records the edit under A's session, including edits made through shell commands like `sed` or a Python script, not only the agent's file-editing tool.
2. **Agent B is about to edit the same file.** Before the edit goes through, gtree adds a note to B's context: `src/auth.ts` was changed a few minutes ago by another session that's still open (gtree looks back 30 minutes), here's what that session is working on, you share this folder with no git isolation, so re-read the file first. If both need the same part, use gtree's `tell` tool to agree with the other session who goes first and who waits.
3. **A hears about it too.** The session whose file was just changed gets its own note: someone else has changed a file you're working on, and the parts you didn't write are theirs, so don't revert them as if they were an accident.
4. **They talk.** B calls `tell` with a message for A ("I need to change `login()` too, are you done with it?"). A sees it the next time it edits a file or finishes a shell command, or when you next type to it. If A is about to end its turn with an unread message, it's held back to read it first. A replies the same way.
5. **The one who goes first says when it's done.** When a turn ends, gtree automatically tells the sessions it has been exchanging messages with that it's finished and which files it changed. The waiting one sees this at its next step, or when you next talk to it, and can carry on.
6. **A broken build isn't blamed on the wrong agent.** If B's build or tests fail on a file another live session changed recently, B is told the bug is probably not its own. It should leave that file alone, tell the other session, and meanwhile work on something that doesn't need a passing build.

All of this happens inside the agents' conversations. gtree doesn't pop up a dialog or ask you to referee, and no edit is blocked: these are notes the agents read and act on. It works between Claude Code and Codex too, so a Codex session and a Claude Code session in the same worktree check in with each other the same way.

You can follow along from the **Inbox** (⌘1): messages one agent left another appear under the receiving session's row while that session is working or waiting for you, marked as not delivered until it has read them. If the receiving session is idle and a message sits undelivered for 10 minutes, it shows up as its own row under Worth a look.

<!-- TODO 截图/视频:两块终端(Claude Code + Codex 或两个 Claude Code)—— B 的输出写明 auth.ts 刚被另一个会话改过、先问一下;B 调用 gtree · tell;A 回话;A 做完自动通知 B。新片第 2 幕片段就绪后放这里 -->

## How do I know two worktrees are changing the same file?

Different worktrees can't overwrite each other, so here the goal is to find out before merge time. gtree watches every worktree's files and refreshes about a second and a half after something changes on disk. When two worktrees have changed the same file, you see it in three places:

- **The sidebar.** That worktree's row ends with an amber △ when no session status icon is showing there (an open session's status icon takes that spot). Hover it to see how many files are also being edited elsewhere.
- **The start page.** Click the worktree and its start page says "N files are also being changed elsewhere". **See which** lists the files and the other worktrees involved.
- **The Inbox.** Overlaps where neither side has committed yet land under **Worth a look**, grouped by which worktrees are involved.

gtree only flags overlaps where at least one side is still uncommitted, because that's where two agents are actively working on the same file. When both sides have already committed, git will show you at merge time, and `git merge-tree` above tells you whether it's a real conflict.

| Kind | What it means | Where you see it |
|---|---|---|
| Both uncommitted | Two agents are changing the file right now | Sidebar △, start page, and the Inbox |
| One committed, one not | One side is done, the other is still changing it | Sidebar △ and start page |

In the Inbox, each overlap has a **Compare** button that opens what changed. To dismiss one, hover it and click **Got it**, or press ⌫. It comes back if the same worktrees start overlapping on more files or the situation changes. Temporary worktrees that AI tools create for their own subtasks are left out, so they don't add noise.

![Worth a look in the Inbox: two overlaps, src/api/client.ts and src/ui/Header.tsx, each changed in two worktrees where neither has committed](/media/app/inbox-light.webp "Overlaps where neither side has committed land in the Inbox under Worth a look. Hover one for Compare and Got it")

## Can an agent check who else is editing a file?

Connecting Claude Code or Codex also gives every session gtree's tools, so an agent can ask on its own instead of waiting to be told:

- **`who_touches`** answers "who else is changing this file?" across this repository's worktrees and the projects that depend on it, and in the current folder it breaks the answer down by session.
- **`who_is_working`** lists what other agents are doing right now.
- **`tell`** leaves a message for another session, as above.

A new session also starts with a short briefing: who else is active in the same folder and in related projects, and which existing worktrees it can reuse (merged, with no uncommitted changes and no session using them) instead of creating another one. So it can steer clear of busy areas before it writes anything.

## Does gtree lock files or block edits?

These are notes and markers, not locks. gtree tells you and the agents about an overlap, but it doesn't stop an edit or pause an agent; whether to wait is up to the agents, guided by the note. Detection also works at the file level: two agents changing different functions in the same file still get a note, and they'll usually just re-read and carry on.

## FAQ

### Can two Claude Code sessions work in the same folder?

Yes, but they share every file with no isolation, so edits can collide at any moment. For real parallel work, give each session its own git worktree. If you do share a folder, gtree tells each agent before it edits a file the other just changed, and lets them message each other to agree who goes first.

### Does Claude Code detect when a file changed under it?

Partly. It refuses to apply an edit if the file changed since it last read it, and asks to re-read. It doesn't know *who* changed it or why, which is the context gtree adds.

### Does this work with Codex?

Yes. Codex sessions get the same notes before editing a file another session just changed, can use `tell`, and send the same "done" message. A Claude Code session and a Codex session in one folder check in with each other the same way two Claude Code sessions do.

### Is a file overlap always a conflict?

No. Git merges changes to different parts of the same file automatically. An overlap means "look before you merge"; `git merge-tree` tells you whether there's an actual conflict.

### Does this work if I start the agent in my own terminal?

Yes. Overlap markers across worktrees come from git and need nothing else. The same-folder notes come from Claude Code and Codex hooks, which report from any terminal once connected.

gtree is free for local use, needs no sign-up, and never uploads your code. [Download gtree](https://gtree.dobbylab.com/) and see which of your worktrees are already overlapping. To see which session needs your attention, read [how to know when Claude Code is waiting for you](/blog/claude-code-waiting-for-approval-notifications/).
