# How to Know When Claude Code Is Waiting for Your Approval

> Claude Code stops whenever it needs permission. Get notified with a Notification hook, and see which of your sessions is waiting on one screen.

Published: 2026-10-13 · DobbyLab · https://gtree.dobbylab.com/blog/claude-code-waiting-for-approval-notifications/

Claude Code pauses whenever it needs your permission to run a tool, and nothing moves until you answer. To find out right away, use its **`Notification` hook**, which fires when a permission prompt has gone unanswered for a few seconds, and when Claude has finished replying and you haven't typed anything for about a minute. With one Claude, a desktop notification from that hook is enough. With several running in parallel, you also need to see *which* session is waiting, which is what gtree's sidebar, Inbox and Dock badge are for.

![The gtree Inbox: 2 things are waiting for you (auth needs permission to use Bash, webhooks is waiting for your reply), two same-file overlaps under Worth a look, and three sessions under Working now. In the sidebar, auth has a bell, dark-mode an idle robot, retry and search a spinner](/media/app/inbox-light.webp "The Inbox puts everything waiting for you, across all projects, on one page. Click a row to jump into that session")

## Why does Claude Code stop and wait?

Claude Code asks before it does anything you haven't pre-approved: running a shell command, editing a file outside its allowed list, fetching a URL. The prompt appears in that session's terminal, and the session is blocked until you choose an option.

That's a good default. The cost shows up when you work on something else in the meantime. A task you expected to finish in ten minutes is still sitting on a permission prompt ("Do you want to proceed?") forty minutes later, because the terminal was behind another window.

If you run [several Claude Code sessions in parallel](/blog/run-multiple-claude-code-git-worktree/), the problem multiplies: five tabs, and any of them may be waiting.

## How do I get a notification when Claude Code needs me?

Start with what's built in. In Ghostty, Kitty and iTerm2, Claude Code sends a desktop notification on its own when it finishes a task or stops at a permission prompt while you seem to be away (in iTerm2, turn on Notification Center Alerts in its preferences). In other terminals you can set `"preferredNotifChannel": "terminal_bell"` in `~/.claude/settings.json` to ring the bell instead, which some terminals turn into a Dock bounce or badge.

For control over what the notification says, use **hooks**: shell commands Claude Code runs on specific events. The `Notification` event is the one you want. Add this to `~/.claude/settings.json` (merge it with any `hooks` you already have):

```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code needs you\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

Restart your Claude Code sessions, and from then on a macOS notification appears whenever one of them is waiting. It fires in two cases:

- **Permission needed:** a permission prompt has been showing for about 6 seconds without any input from you.
- **Done and waiting:** Claude finished replying and you haven't typed anything for about 60 seconds.

The hook also receives a JSON payload on stdin with a message explaining why and the session's working directory, so a small script can put the project name in the notification. If you want a ping the moment Claude finishes, without the one-minute wait, add a `Stop` hook as well. It fires after every reply. Just don't let the script exit with code 2: that tells Claude not to stop, and it keeps going.

### Where the DIY approach runs out

The hook works, but a few things get in the way once you rely on it:

- **Notifications sent by `osascript` belong to Script Editor.** If notifications for Script Editor are turned off in System Settings (which is common), the command still succeeds and nothing appears.
- **Clicking the notification doesn't take you anywhere.** You still have to find the right terminal tab.
- **It's a moment, not a state.** Miss the banner and there's no list of what's still waiting.
- **There's no overview.** You can't see which sessions are running, which are idle and which have been quiet for half an hour.

## How gtree shows which agent is waiting

[gtree](https://gtree.dobbylab.com/) turns the same events into something you can see at a glance. Connect Claude Code once: on the last page of the welcome tour, or in Settings (⌘,). Until you do, the start page shows a "Claude Code isn't connected" note with a **Connect Claude Code** button. gtree adds its own hook entries to `~/.claude/settings.json`, leaves everything else in that file alone, and from then on knows the state of every session, including the ones you start in your own terminal. Codex sessions report the same way once you connect Codex in Settings: working, and waiting for your permission or your answer.

### The sidebar: one marker per worktree

Every worktree in the sidebar ends with a single status marker. You read the shape, not text:

- **Purple spinner**: its agent is thinking or running a tool.
- **Pulsing red bell**: it's waiting for you.
- **Faded purple robot**: the session is open but idle.
- **Faded terminal icon**: only a terminal is open, with no agent running in it.

Hover the icon to see what it's doing or waiting for, such as "waiting for you". If a collapsed project has a session waiting inside it, the project name gets a red dot.

### The Inbox: everything that needs you, in one list

The **Inbox** (⌘1) answers one question: *is anything waiting for me right now?* At the top, "N things are waiting for you", one row each. Click a row to jump straight into that session, or use ↑↓ and ↩. For a session running in gtree, that switches to its terminal tab; for one running in another terminal app, gtree can't switch windows for you, so it opens a read-only replay of the conversation.

Below that, **Worth a look** collects things that aren't blocking yet but may need you:

- a session that still says it's working but hasn't done anything for 10 minutes or more;
- two worktrees changing the same files, with neither side committed;
- one agent that has waited too long for another agent to answer its question;
- a message one agent left another that still hasn't been delivered after 10 minutes;
- an answer to a question you asked another agent, which you can expand in place.

Dismiss any of these with **Got it** (or ⌫); it comes back if the situation changes. Then comes **Working now**, the sessions that are busy. When nothing is waiting, the Inbox simply says **All good**.

The Inbox count covers **all** your projects, not only the open one. The same number appears on gtree's **Dock icon**, and it keeps updating while the window is closed.

### Native notifications that take you to the session

When a session starts waiting, gtree posts a macOS notification under its own name, so it doesn't depend on Script Editor's notification settings. Clicking it takes you to that worktree's session (or, for a session in another terminal, to its read-only replay). gtree also stays quiet when there's no need to interrupt:

- If you're already looking at that session in gtree, there's no notification.
- The same worktree won't notify again within 10 seconds, so a burst of permission prompts is one notification.

gtree asks for notification permission on the last page of the welcome tour, not in the middle of your work. In Settings you can check that notifications are on and click **Send a test**.

<!-- TODO 截图:0.3.14 设置 › 通知(On + Send a test)。旧图 settings-general-notifications-light.webp 拍于 0.3.8,核对 0.3.14 布局一致后可直接复用 -->

### What about "done"?

When an agent finishes a turn, the spinner stops. If you don't reply, Claude Code fires its idle notification after about 60 seconds, and gtree treats it like any other wait: bell, Inbox entry, notification. So you hear about a finished task about a minute after it ends. That "done, waiting for your reply" bell clears as soon as you switch to that session's terminal tab; you don't have to type anything. (Codex doesn't send an idle event, so its sessions get a bell only when they need permission or ask you something.)

### Sessions running outside gtree

Sessions you start in iTerm or another terminal report through the same hooks, so they show up in the sidebar and Inbox too. The status bar tells you where they live, for example *1 AI open in iTerm*.

## DIY hook vs. gtree

| | `Notification` hook + `osascript` | gtree |
|---|---|---|
| Alert when the agent needs permission | Yes | Yes |
| Shows which project and worktree | If you script it | Yes |
| Click the alert to reach the session | No | Yes |
| List of everything still waiting | No | Inbox |
| Count on the Dock icon | No | Yes, across all projects |
| Skips alerts while you're looking | Can't | Yes |
| Running / idle status for every session | No | Sidebar icons and the Inbox |

## FAQ

### Which Claude Code event fires when it needs approval?

The `Notification` hook. It fires when a permission prompt has gone about 6 seconds without input, and when Claude finished replying and you haven't typed for about 60 seconds. The payload includes a message describing why. To react the instant the permission dialog appears, use the `PermissionRequest` hook.

### Does this work with Codex?

Yes. Connect Codex in Settings and its sessions get the same spinner, and the same bell when they need permission or ask you something. Codex doesn't send an idle event, so there's no "done, waiting for your reply" bell for it.

### Does gtree slow down Claude Code?

No. gtree's hooks take a few milliseconds each, so Claude never waits on them, and if something goes wrong on gtree's side they simply step aside and the conversation carries on.

### Can I stop gtree from changing my Claude Code settings?

Yes. In Settings you can see each hook gtree added and what it's for, turn individual ones off, or disconnect Claude Code entirely (Codex can be disconnected there too). gtree only adds and removes its own entries.

### Do I need to run the agent inside gtree for this to work?

No. Once Claude Code is connected, sessions in any terminal report their status. Running them in gtree's built-in terminal adds one extra: gtree can tell whether Claude is working from the terminal title, even before any hook has fired.

gtree is free for local use, needs no account, and never uploads your code. [Download gtree](https://gtree.dobbylab.com/), connect Claude Code, and let the bell tell you which agent needs you.

*Updated for gtree 0.3.14 (Oct 2026).*
