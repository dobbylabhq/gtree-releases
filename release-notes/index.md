# Release notes

What changed in each version. If you already have gtree, the sidebar shows “Update and restart” when a new version is out.

## v0.3.19 (2026-10-28) — Hold ⌘ to see images in the terminal, open folders that aren't Git repositories, and reorder projects by dragging

### Improved
- See images right inside the embedded terminal: hold ⌘ over an image path (like `/tmp/shot.png`, `~/Desktop/a.jpg`, or a path relative to the current folder) or the "[Image #3]" Claude Code shows for a pasted image, and a preview appears next to it. ⌘-click to open it large, with "Reveal in Finder" underneath. No more digging through Finder for a screenshot an agent took or an image you pasted.
- ⌘O can open a folder that isn't a Git repository. You can still start AI sessions, open terminals and browse files. The start page and the History page offer "Create Git repository", which turns it into a Git project in one click.
- Projects in the sidebar can be reordered by dragging, and keep that order the next time you open gtree.
- The update card at the bottom of the sidebar no longer gets cut off. Next time a new version is out, click "See what's new" on the card to read what changed.

### Fixed
- With Claude Code set to a dark theme, the question text in its prompts was white on gtree's light terminal background and looked blank. The terminal now adjusts text that's too close to its background so it stays readable.
- Clicking a line in the sidebar's "Merged" group moved it up into the list above, away from where you clicked.
- After upgrading from 0.3.7 or earlier, gtree crashed once on first launch.

## v0.3.18 (2026-10-28) — Go to definition in the file view, search in the right panel, and a collapsible file list in Diff

### Improved
- Go to definition in the file view: hold ⌘ and hover a name to underline it, then ⌘-click, press F12 or right-click "Go to Definition" to jump there with the name selected. If the definition is in another file, it opens in the file view. When a name is defined in more than one place, a picker lists each one with its path, line number and that line of code. ⌃- / ⌃⇧- go back and forward to the file and line you came from. Works for Rust, JavaScript / TypeScript, Python and Go, with no language server to install. The first time you open a source file in a worktree, it takes a moment to prepare in the background; until then, jumping does nothing.
- Search across files (⌘⇧F) moved into the right panel as a third tab next to "Files" and "Changes", so it no longer covers the code you're reading. Click a result to open it in the main area; the results stay in the panel so you can move on to the next one.
- The file list on the left of Diff, uncommitted changes and "AI turns" can collapse into a narrow strip to give the code more room. It stays collapsed the next time.
- ⌘T and the "+" on the tab bar now offer "Open terminal", after New Claude Code session and New Codex session.

### Fixed
- In Diff, the order of files on the right didn't match the file tree on the left: for example, Dockerfile came before the config/ folder while the tree listed it last.
- When scrolling long lines sideways, the code and its background ran right up to the right panel's edge, as if the panel covered part of it.
- Opening a file from a search result sometimes didn't land on the matching line.

## v0.3.17 (2026-10-23) — Horizontal scrolling in Diff, a ⌘⇧P command palette and Markdown / PDF preview, and worktrees in use still visible under collapsed projects

### Improved
- Long lines in Diff are no longer cut off: the content area scrolls horizontally (swipe sideways on the trackpad or drag the scrollbar at the bottom), while line numbers, file headers and "⋯ N unchanged lines" rows stay pinned on the left. Details of an AI turn and of uncommitted changes work the same way.
- New ⌘⇧P command palette. It shares the ⌘P overlay: type > to search commands instead of files. Every command shows its shortcut, and only the ones that apply right now are listed.
- The file view previews Markdown (switch between "Preview" and "Source" in the header) and PDF (page by page). "Markdown preview" and "PDF preview" are built-in plugins, on by default, and can be turned off in the new "Plugins" section of Settings.
- The History overlay (⌘Y) has a "This worktree" toggle (⌘E) next to the search box, showing only conversations from the current worktree. It's remembered across launches.
- Collapsed projects in the sidebar still show the worktrees in use: ones with a tab open, with an agent running, or waiting on you are no longer hidden, and a click switches to them.
- Color refresh: AI-related colors moved from purple to the deep teal of the logo, branch colors in the graph are softer, and red, green and amber switch to lighter shades in the dark theme.

### Fixed
- Shortcuts stopped responding after closing the ⌘P / ⌘⇧P overlay; clicking the search box in ⌘P, ⌘Y or the new-session picker closed the overlay.
- A newly created directory (not yet added to git) showed in the file tree as a single file with no name, and none of the files inside appeared. Files are now listed one by one; files ignored by .gitignore are shown too (greyed), and ignored directories such as node_modules list their contents only when you open them.
- The Inbox ("Worth a look", the rows under "Working now" and the lines in the graph) no longer lists messages that can never be delivered because the recipient's session has ended, nor the "[auto]" notifications gtree sends on an agent's behalf; the automatic "I've finished this turn" notices no longer pile up one per turn.
- After collapsing the current project, the selected worktree sat between the project names with a grey background, looking like a selected project.

## v0.3.16 (2026-10-15) — Every changed file in one scroll, images and history in the file view, and project renaming

### Improved
- Diff now reads like a GitHub pull request: every changed file is stacked in one long view, so you can scroll straight through all the changes. Click a file on the left to jump to it, or click a file's header to collapse or expand it. "Full file / Changes only" now switches per file. Details of an AI turn and of uncommitted changes work the same way.
- Select text in a diff and a "Copy selection" button appears at the top right. File headers and folded "⋯ N unchanged lines" rows are left out, so you copy only the code.
- Images (PNG, JPG, WebP, GIF, SVG and more) open as pictures in the file view, scaled to fit. SVGs can switch to "View source". Very large images aren't previewed.
- A new "History" panel in the file view lists the commits that touched the file, even across renames. Click one to see that commit's changes in Diff.
- Right-click a project in the sidebar and choose "Rename" to rename it in place. Press ↩ to save or esc to cancel; leave it empty to go back to the folder name. The new name is used in the Inbox, notifications, and the "you're in project …" that gtree tells your agents.

### Fixed
- When you switched back to the Inbox, the list could show stale items for a few seconds that didn't match the sidebar badge.
- Opening a repository from one of its worktree folders could list it twice in the Inbox, with each agent waiting on you listed twice and the wrong project name passed to your agents.

## v0.3.15 (2026-10-15) — Lighter while agents work, and notes to your agents in English

### Improved
- gtree uses about half as much CPU while agents are working. The spinning and blinking agent status icons now redraw about 12 times a second instead of at your screen's refresh rate. In our test with three agents working and one waiting, gtree went from 8.6% to 4.4% of one core. With nothing running it stays under 1%.
- What gtree tells your agents now follows the app's language: Chinese when gtree is in Chinese, English otherwise. This covers the heads-up when another session in the same worktree just changed a file, notes left by other sessions, the "who's working on what" summary at the start of a session, and the descriptions of gtree's MCP tools.
- The "Claude Code isn't connected" notice on the start page is now a card: the explanation gets a full line and the buttons sit below it.
- The welcome guide's text matches the current app: agents in the same worktree check with each other before editing the same file, "AI turns" and ⌘Y replace the timeline, and the Inbox replaces the collaboration view.
- Status tooltips now start with "AI ·" instead of "Claude ·", since they cover Codex sessions too.

### Fixed
- In an empty repository, the file tree's loading placeholder kept animating and never went away.
- With the app in English or Japanese, tool steps in a conversation replayed from History (such as "Edit src/theme.ts") were shown in Chinese.
- On the start page, the list of files also changed elsewhere could squeeze the file path down to nothing. The worktrees involved now go on a second line.
- The Inbox no longer points to the Workbench, which no longer exists. It now just says how many more there are.
- Settings no longer mention the Workbench or the timeline when describing Claude Code hooks. The Team plan description no longer lists Teammates, which is already in the free version, and now says the relay only forwards sync messages and doesn't store your data.

## v0.3.14 (2026-10-15) — Picks up where you left off, and one click shows the diff

### Improved
- Quit gtree and open it again: the projects you had open, the one you were on, and the worktree selected in each are all still there. No need to add your projects again.
- "View changes" on the start page, and clicking a file under Changes on the right, now open the diff in the middle: changed files on the left, the contents on the right, new files included. Staging and unstaging use only the + / − at the end of the row, so clicking a file no longer stages it.
- "Open in editor" on the start page is now "Open a file": the right panel switches to the file tree and the ⌘P file finder opens. The file you pick opens in gtree, ready to edit and save.
- When a branch has been rebased and no longer matches its remote copy, the start page shows one line, "Rebased: differs from the remote copy of this branch", with a "Push (overwrite remote)" button that asks first, instead of offering both Pull and Push. It doesn't appear if someone else has pushed new changes to that branch.
- A long reply in a turn's details shows 4 lines at first and can be expanded, so the changes below stay on screen.
- Projects in the sidebar, "Merged", "AI temporary workspaces", "AI turns", and the start page's list of files changed elsewhere now open and close with an animation, with rows appearing one after another. The "AI turns" heading stays in place when you collapse it.

### Fixed
- Clicking the file filter in global search no longer closes search. ⌘⇧F now always opens search, and pressing it again no longer closes it.
- The selected line in the sidebar sometimes jumped to a different one.
- The start page's list of files changed elsewhere only shows files that involve the current line, and no longer carries over when you switch lines.
- The line separating sessions in "AI turns" overlapped the text of the next row.

## v0.3.13 (2026-10-14) — A clearer right panel: tabs you can spot, and a commit box that grows

### Improved
- The Files and Changes tabs in the right panel have a new look. The selected tab has darker text and an underline, so it's clear you can switch. Changes shows how many files are uncommitted, and Files no longer shows the repository's total file count.
- The Changes tab has a new layout. When the working tree is clean, the top part shrinks to a single line that reads "Uncommitted" and "Clean", leaving the space for AI turns below. "Discard all" moved into the "⋯" menu.
- Each AI turn now takes two lines: your prompt and the time, then how many files changed and which ones (like "3 files · root.rs and more"). The colored bar on the left is gone, and a line now separates one session from the next. "Show turns without file changes" and "Legacy snapshots" moved into the "⋯" menu.
- You can collapse AI turns. Click the heading and the section shrinks to one line at the bottom of the panel. It stays collapsed the next time you open gtree.
- The commit message box grows as you type, up to 4 lines, then scrolls. You can read a longer message in full, and the file list above stays visible.
- In the Inbox, the spinner for an AI at work now spins and the bell for one waiting on you now pulses, just like in the sidebar.

### Fixed
- Tabs on the AI page were squeezed down to a single icon, hiding their names (introduced in 0.3.12).

## v0.3.12 (2026-10-14) — New layout: click a line to see what's next, and MR status in the sidebar

### Improved
- New layout. The sidebar now holds just Inbox, History, and your projects. Click a line in a project to open its home: the conversation if a session is open, otherwise the line's start page. The Workbench is gone. Shortcuts: ⌘1 Inbox, ⌘2 Current Worktree, ⌘3 History.
- The start page shows where the line stands, with a button for each situation: already merged (Delete worktree / Start a new branch), the same file is being changed elsewhere (See which), uncommitted changes (View changes), new commits on the remote (Pull), commits not pushed yet (Push), an open MR (Open MR), no MR yet (Create MR), behind the main branch (rebase). Below that: start Claude Code or Codex, open a terminal, or open in your editor.
- The right panel now has two tabs, Files and Changes (⌥⌘B toggles it, ⇧⌘E / ⌃⇧G switch tabs). Changes lists your uncommitted files (stage and commit there) and each AI turn. Click a turn to see what it changed in the middle. The old "Changes" view is now called History.
- The sidebar shows MR status after each branch: a pull request icon while it's open, a faded merge icon once it's merged. Hover to see the number, title and link, and click to open it in your browser. It uses the glab or gh you're already signed in to, and works with GitLab (including self-hosted) and GitHub. If neither is installed, nothing is shown.
- Each line in the sidebar ends with a single marker: the AI session's status (working, waiting for you, etc.), the same file being changed elsewhere (amber △), or how many lines are uncommitted (like "+24 −3"). Hover for details.
- Lines whose branch is merged and that you're not using fold into "Merged · N" at the bottom of the sidebar. Branches squash-merged on the platform count too, even when git can't tell.
- Right-click a line in the sidebar for the Git menu (push, pull, commit, switch branch, delete worktree and more). With many worktrees, the project name stays pinned at the top so you can collapse it anytime.
- Click a line whose AI is working or waiting for you to open that conversation, from any page.
- The AI page no longer starts Claude Code on its own, so just looking doesn't add a session. Click "New Claude Code session" on the start page or press ⌘T to start one (you can choose if Codex is installed).
- Past conversations now open in a small window at the top of the AI page (⌘Y). Type to search, ↩ to continue, ⌘↩ to just read. Clicking a conversation in the list continues it too.
- Closing a tab with Claude Code running (⌘W) asks first. You can check "Don't ask again" and turn it back on in Settings.

### Fixed
- The "done, waiting for your reply" bell clears as soon as you switch to that terminal tab. You no longer have to send a message.
- Clicking an item in the Inbox switches to the session tab it belongs to, and the keyboard selection no longer jumps to another row when the list refreshes.
- Clicking title bar buttons quickly no longer zooms the window.
- Long URLs wrapped onto two lines in the terminal now open with ⌘-click.

## v0.3.11 (2026-10-13) — See what needs you first on the Workbench, and a rebuilt Inbox

### Improved
- The Workbench is now one row per worktree, grouped by urgency. What needs you (waiting for you, merge conflicts) comes first; worktrees with no changes and no AI at work, or whose branch is merged, fold away. Each row shows the full branch name, then the worktree name and what changed. Buttons appear on hover.
- When two worktrees change the same file, it's noted on the row (click for the file list) instead of a permanent orange banner.
- Status colors in the Workbench, status bar, file tree and search now mean just four things: red needs you, amber is risky, purple is an agent at work, green is staged.
- With Claude Code or Codex connected, an agent gets a list of worktrees it can reuse at the start of a session (and again when you mention worktrees), so it doesn't have to create a new one.
- Inbox is rebuilt: click a row to jump to that session, or use ↑↓, ↩, and ⌫ to dismiss.
- The "AI activity" column on the right of Inbox is gone. Questions agents are asking each other, and messages they left, now appear under the row they belong to. "Worth a look" also shows an agent waiting too long for another's answer, a message that hasn't been delivered, and an answer to a question you asked (click to expand it in place).
- Inbox's list and the Project map now scroll separately. Drag the map with two fingers, pinch to zoom, and double-click empty space to fit it in the window.
- Find in all files (⌘⇧F) is redesigned: results appear as you type, grouped by file with matches highlighted. Match case, match whole words, search only files with uncommitted changes, or narrow the files with patterns like `*.rs  !tests`.
- Built-in terminal: ⌘-click a link to open it, ⌘← / ⌘→ jump to the start / end of the line, ⌥← / ⌥→ move by word, and dragging a file in from Finder types its path. Claude Code recognizes images dragged in this way.
- Opening a file now expands the file tree to it.
- History on the AI page is grouped into Today, Yesterday, Previous 7 days and Older, and the headings stay pinned as you scroll.

### Fixed
- When gtree isn't running (after ⌘Q, for example), using Claude Code or Codex in another terminal no longer triggers gtree notifications.
- Continue this session now switches to its terminal tab if the session is already open in gtree.
- Search: ↩ now opens the selected result, results in paths with Chinese, Japanese or other non-English characters open again, and an earlier search no longer replaces newer results.
- Session titles with line breaks no longer break the History list.
- The Project map is no longer stretched and cut off on the right, and a project named "/" no longer appears.

## v0.3.10 (2026-10-10) — Edit files right where you open them

### New
- Files you open can now be edited. ⌘S saves, and switching to another file saves automatically.
- If a file was changed elsewhere (by an agent, say) after you opened it, saving won't silently overwrite it: you choose to reload it (discarding your edits) or overwrite anyway. Auto-save on switching files never overwrites in that case; it tells you which file wasn't saved.
- Files that aren't UTF-8 open read-only.

### Improved
- The buttons that collapse and expand the sidebar, the file panel and AI history now share one panel icon.

## v0.3.9 (2026-10-10) — Codex support, agents that sort it out between themselves, and Teammates

### New
- Connect Codex: click Connect Codex in Settings and Codex sessions work like Claude Code ones. You can see what each one is doing and when it's waiting for you, waiting sessions show up in Inbox, and every turn is saved so you can roll it back. No need to approve anything inside Codex.
- The + in the AI view can open a Codex session next to your Claude Code ones in the built-in terminal, and History now finds and replays Codex conversations too.
- Agents in the same worktree, Claude Code or Codex, now know about each other: when one changes a file the other also changed, the other is told automatically, and before touching the same place they leave each other a message to agree who goes first. Whoever finishes first tells the other.
- New Teammates, off by default and turned on per repository: in repositories where someone else has committed recently, a Teammates section appears under the project in the sidebar. Click Turn on, then Start sharing, and you and your teammates see each other's work in progress, uncommitted changes included, through your team's own git repository. Click a branch to see their changes.
- When you and a teammate change the same place, your AI stops and asks you before editing, and Inbox flags it with a See their changes button.
- Your AI can leave a teammate a message. It reaches their AI only after they have read it and clicked Hand to my AI, and the reply comes back to the AI that asked.
- Everything between teammates is signed and messages can only be read by their recipient, so no one else with access to the repository can pose as a teammate. If a teammate's identity changes, nothing from them is accepted until you confirm it's really them.

### Improved
- Clicking "AI open in another terminal" in the status bar now lists those sessions: what was asked, how long ago and what it's doing. Click one to switch to its terminal, or, if gtree can't tell where it runs, to replay the conversation.
- Right-click in the file tree to Open in Browser, Open with Default App, Reveal in Finder, Open in Terminal (gtree's built-in terminal) or Copy Path.

### Fixed
- Paging through the welcome tour no longer flashes other screens, and its last page now shows how to connect Claude Code.
- When long commands run in parallel in one worktree, files are no longer credited to the wrong session, and "0 failed" in test output is no longer taken for an error.
- The Claude Code connection text no longer mentions error or stuck states the app never shows.

## v0.3.8 (2026-10-09) — An Inbox, native notifications and four-item navigation

![The gtree Inbox: sessions waiting for you at the top, each with Open; under Worth a look, two worktrees changing the same file; the AIs currently working at the bottom](/media/app/inbox-light.webp "The new first screen, Inbox: who's waiting for you and where work overlaps, on one page")

### New
- Inbox is the new first screen and answers one question: does anything need you right now? AIs waiting for you come first, sorted by how long they've waited, followed by things worth a look, such as two branches changing the same file.
- Get a macOS notification when an AI stops to wait for you, whether it needs permission or has finished and is waiting for your reply; click it to jump to that session. The Dock icon shows how many things are waiting.
- When two Claude Code sessions work in the same worktree, an AI is warned before it edits a file the other just changed, so they don't overwrite each other.
- Remove gtree from this Mac right from Settings: it disconnects Claude Code, deletes gtree's data (or keeps it if you plan to reinstall) and moves the app to the Trash.

### Improved
- Navigation is down from seven items to four: Inbox, Workbench, Changes and AI, on ⌘1–⌘4. Changes holds AI changes, History and Compare.
- Connecting Claude Code takes one click from the welcome tour, the Workbench banner or the empty AI changes page, and asks for notification permission at the same time. No Terminal commands.
- Compare opens with something to show: the main branch versus your current worktree.

### Fixed
- Repositories with hundreds of branches no longer slow your whole Mac down.
- Closing a terminal tab now ends the Claude running inside it, and several Claude tabs in one worktree no longer overwrite each other's status.
- Updating and connecting Claude Code no longer fail when gtree runs straight from your Downloads folder, and gtree offers to move itself to Applications in one click.

## v0.3.7 (2026-10-09) — Move gtree anywhere without breaking Claude Code

### Improved
- Moving gtree.app to another folder no longer quietly breaks its connection to Claude Code; existing connections switch over automatically on first launch.

### Fixed
- The install command no longer fails with “unbound variable” in some terminals, an error that stopped many new users from installing since 0.3.3.

## v0.3.6 (2026-10-09) — New installs counted correctly in usage statistics

### Fixed
- New installs are now counted in anonymous usage statistics on their first day — still only after you've seen the notice, and you can turn statistics off in Settings.

## v0.3.5 (2026-10-09) — Reliable first launch for browser downloads

### Fixed
- Opening gtree from a .zip downloaded in a browser no longer reports “gtree is damaged and can't be opened”: the app is now fully signed, so macOS only asks you to allow it once (System Settings → Privacy & Security → Open Anyway).

## v0.3.3 (2026-10-09) — Set up the Claude Code integration from Settings

![The Claude Code connection section in gtree Settings: Not connected, a Connect Claude Code button, and a short explanation of what connecting does](/media/app/settings-claude-not-connected-light.webp "Connect Claude Code from Settings in one click, with what it does and what it changes explained right there")

### New
- Settings has a new Claude Code integration section: install in one click, see in plain words why it helps and what it changes, pick the install folder, review and switch off each hook, or uninstall.
- The Workbench shows a banner when the Claude Code integration isn't installed or needs an update, linking straight to Settings.
- Drag AI tabs to reorder them; the tab bar scrolls when there are more tabs than fit.
- Settings previews the upcoming Team plan, with expected pricing and an early-bird list.

### Improved
- The Timeline explains what it's for, lists only turns that changed files by default, and shows system messages and Markdown as readable text.
- The sidebar, file panel and AI history panel now open and close with a smooth animation.
- Command-line output and `gtree --help` follow your interface language.

### Fixed
- Sidebar content no longer slides over the window buttons while the sidebar opens or closes.
- Past conversations no longer stay stuck as “open in another terminal”, and can be resumed again, after Claude Code subagents finish.

## v0.3.2 (2026-10-09) — gtree now speaks English and Japanese, plus a welcome tour

![The General section of gtree Settings: a language switch with English, 日本語 and 中文, and a Replay button for the welcome tour](/media/app/settings-general-notifications-light.webp "Switch the interface language any time in Settings, and replay the welcome tour from the same place")

### New
- The interface is now available in English, Japanese and Simplified Chinese; it follows your macOS language and can be switched in Settings, taking effect immediately.
- A gear button at the bottom-left of the sidebar opens Settings and shows the current language.
- New users get a six-page welcome tour on first launch; replay it any time from Settings → General.

### Improved
- The welcome tour respects macOS “Reduce motion”, fading instead of animating.
- The install command now prints its progress in English.

### Fixed
- Panel titles on the Workbench are no longer cut off in English and Japanese.
- Network view cards no longer show raw system tags in place of what you asked.

## v0.3.1 (2026-10-08) — New Settings panel with a usage statistics switch

### New
- Added Settings (⌘, or gtree → Settings… in the menu bar); its first option turns anonymous usage statistics on or off at any time.

### Improved
- The first-launch notice about usage statistics is written in plainer language and points you to Settings.

## v0.3.0 (2026-10-08) — Timeline — review and restore every AI turn

![The AI changes page: turns that changed files in the middle; on the right, the selected turn's prompt, Claude's reply, the changed files and their diff, with Restore to this turn in the corner](/media/app/ai-changes-timeline-light.webp "Every turn's prompt, reply and changes are kept, and Restore to this turn puts that turn's files back")

### New
- Timeline replaces Snapshots: after each Claude Code turn, gtree records your prompt, the reply and the files that changed, so you can review each turn's diff and restore the files that turn changed without touching your branch or staging area.
- New Claude Code sessions start knowing where the last session in the same worktree left off: what was asked, the final reply and which files changed.
- The AI can look up earlier turns by itself, including turns from your other projects.
- The commit graph can show how each AI turn ended, as a branch growing from your current commit; show or hide it from the toolbar.
- The Network view opens with a card for each active AI, showing what it's working on and what it did last turn, with the ones waiting for you first.
- “Take a look” jumps straight to the Claude working in a worktree: its AI tab if it runs in gtree, or a read-only replay if it runs in your own terminal.

### Improved
- Downloads and updates go through gtree's own download server, falling back to GitHub automatically if it can't be reached.
- gtree now collects anonymous usage statistics and tells you on first launch before anything is sent; turn them off from that notice or with GTREE_NO_TELEMETRY=1.
