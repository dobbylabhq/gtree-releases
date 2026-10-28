# Privacy Policy

Last updated: 2026-10-16

## Summary

gtree is a desktop app that runs entirely on your computer. There is no gtree account and no sign-in. **gtree never uploads your source code**, file names, paths, repository names, git settings, or Claude Code or Codex conversations to us. The only thing the app sends to DobbyLab is an anonymous usage ping attached to the regular update check, and you can turn it off with one click.

This policy covers the gtree app, the website at https://gtree.dobbylab.com and the download server at https://gtree-dl.dobbylab.com. They are run by **DobbyLab**, an independent developer (tzyito), not a registered company.

## What the app sends

gtree checks for updates 10 seconds after launch and then every 6 hours. Only the official release build does this. The check fetches a small version file from `gtree-dl.dobbylab.com`. If that server is unreachable, gtree fetches the same file directly from GitHub, without any usage data.

When anonymous usage statistics are on, the update check also carries four values:

- **A random device ID.** 32 hexadecimal characters, generated on your Mac the first time and stored in `~/.gtree/device-id`. It is not derived from your hardware, your name or your Apple ID.
- **The gtree version** (for example `0.4.1`).
- **The CPU architecture** (`aarch64` or `x86_64`).
- **The macOS version** (for example `15.3`).

We use these numbers to count daily active devices, new devices and which versions are in use. Nothing else rides along.

**gtree tells you before it reports anything.** The first time the release build starts, an "Anonymous usage statistics" card appears in the sidebar. Until that card has been shown, no usage data is sent at all.

When you download an update, the download goes through `gtree-dl.dobbylab.com` too. That adds one to the day's download count for that version, and to a separate count by country.

## What the app does not send

gtree never sends DobbyLab:

- your source code, diffs or file contents
- file names, folder paths, repository names or remote URLs
- your git configuration, user name, email or commit history
- your prompts to Claude, Claude's replies or session history
- crash reports (gtree has no crash reporting)

## How to turn statistics off

Any of these works. Update checks keep working; they just stop carrying the four values above.

- Click **Turn off** on the first-launch card.
- Open **Settings** (⌘,) and switch off **Anonymous usage statistics**.
- Create an empty file at `~/.gtree/telemetry-off`.
- Launch gtree with the environment variable `GTREE_NO_TELEMETRY=1`.

To stop update checks entirely (and with them all contact with our server), launch gtree with `GTREE_NO_UPDATE=1`. You will then need to update by hand.

## Data that stays on your Mac

gtree keeps its working data locally. None of it is sent to DobbyLab.

- **`~/.gtree/`**: settings, the device ID, and a local database (`gtree.db`) that lists your projects and, if you use Claude Code with gtree, a record of each Claude turn (your prompt, Claude's final summary, changed files) so that later sessions can pick up where earlier ones stopped.
- **Inside each repository's git folder**: Claude session status files (`.git/gtree/`) and checkpoint commits under `refs/gtree/agent/`. gtree does not push these refs anywhere.
- **Claude Code integration**: if you install it, gtree adds its own hook entries to `~/.claude/settings.json`, adds three small scripts (by default in `~/.claude/gtree/`) and registers a local MCP server with Claude Code. The hooks pass events to gtree on your Mac; they do not contact any server. gtree only adds or removes its own entries and never touches entries from you or other tools.
- **Codex integration**: when you connect Codex, gtree adds its own hook entries to `~/.codex/hooks.json`, adds three small scripts in `~/.codex/gtree/`, registers a local MCP server through Codex's own command, and marks those hooks as trusted in `~/.codex/config.toml` so you don't have to approve each one inside Codex. Before opening Codex from gtree, it also marks that repository as a trusted Codex project (`[projects."<repository path>"]` in `config.toml`; an existing entry is left as it is). As with Claude Code, the hooks pass events to gtree on your Mac and do not contact any server, and gtree only adds or removes its own entries, never yours or other tools'. To search and replay Codex sessions in History, gtree reads the records under `~/.codex/sessions/` on your Mac.
- **Notifications** are shown through macOS Notification Center on your Mac. gtree asks for permission first.

**Settings → Remove gtree** removes the Claude Code and Codex integrations, the gtree data in your repositories and `~/.gtree/`. You can also choose to keep your data. The Codex project trust entries are kept; you can delete them from `~/.codex/config.toml` if you no longer need them.

## AI features, Claude Code and Codex

gtree does not include its own AI model and does not call any AI service. It starts **your own** `claude` or `codex` command-line tool in a terminal on your Mac. What you type to Claude, and the code Claude reads, is handled by Claude Code under your agreement with Anthropic; with Codex, it is handled by Codex under your agreement with OpenAI. None of it passes through DobbyLab.

To let your sessions know about each other, gtree hands some information from your Mac to your Claude Code or Codex sessions: what other sessions are doing, which files they changed, and the prompts and summaries of earlier turns, sometimes including this information from your other projects. It becomes part of that conversation and, like anything else you share with the AI, is handled under your agreement with Anthropic (Claude Code) or OpenAI (Codex). None of it is sent to DobbyLab.

## Git operations

gtree runs your system `git` for actions such as fetch, pull and push. While a repository is open, gtree runs `git fetch` in the background about every 3 minutes. These connections go directly from your Mac to the remotes you configured (GitHub, GitLab, your own server and so on), using your own credentials. DobbyLab never sees them.

## Teammates (off by default)

Teammates lets you and your teammates see each other's work in progress. It is **off by default** and turned on per repository: the Teammates section only appears in the sidebar for repositories where someone else has committed recently, and it takes effect only after you click Turn on, read the explanation and click Start sharing. The setting is stored in that repository's git config (`gtree.shareLive`).

When it is on:

- **What is synced**: code in that repository the team doesn't have yet (uncommitted changes, new files and commits you haven't pushed), together with the branch name, is pushed to **your team's own git remote**, under a location that doesn't show up as a branch (`refs/gtree/`). Files ignored by `.gitignore`, untracked files over 1 MB and AI temporary workspaces are left out. gtree pushes automatically after you make changes and regularly fetches your teammates'.
- **Who can see it**: anyone with read access to that remote, and the platform hosting it (such as GitHub or GitLab), can see the synced code. DobbyLab is not involved, and no server of ours takes part.
- **Identity**: to stop anyone posing as you, gtree creates a key for your git email on your Mac (the private key is stored in `~/.gtree/team-keys/`, readable only by you, and never leaves this computer) and pushes the public key with your name and email to the same remote. Everything synced is signed by you.
- **Messages**: messages your AI leaves for a teammate travel through the same remote and are **end-to-end encrypted** so that only the recipient can read them; others in the repository can see only that there is a message and who it is for, not its content. A new message reaches the recipient's AI only after they have read and confirmed it; a reply to a question your AI asked goes straight back to the AI that asked. Once handed to an AI, it is handled under the recipient's agreement with their AI provider.
- **Turning it off**: you can turn it off at any time. Syncing stops and what was pushed is removed from the remote; copies teammates have already fetched can't be taken back.

## Website

- The website is static and hosted on **GitHub Pages**.
- We use **Cloudflare Web Analytics** to count visits. It does not use cookies. It loads only on `gtree.dobbylab.com`.
- When a page opens, it asks `gtree-dl.dobbylab.com` for the latest version number. That adds one to a daily count of page opens (with country).
- The site uses your browser's local storage for three conveniences: your theme choice, your language choice, and a note that you already joined the Team plan early-bird list. These stay in your browser and are never sent to us.
- The site sets no cookies of its own.

## Download server

`gtree-dl.dobbylab.com` is a Cloudflare Worker that passes through installers and the install script from our public GitHub releases. For each request it adds one to a **daily count** by type (download, install script, version check, page open), version and country.

- The country is the two-letter code Cloudflare derives from your IP address. **We do not store IP addresses.**
- Counts are aggregated per day. We do not keep a log of individual downloads.
- The only per-device data comes from the update check described above: one row per device per day (device ID, version, CPU type, macOS version and country), and one row per device recording the date it was first seen, used to count new devices.

## Team plan early-bird list

If you join the Team plan early-bird list on the website, we store:

- your email address
- the team size you picked (optional)
- the date you signed up
- your country (derived by Cloudflare from your IP; the IP is not stored)

We use your email only to tell you when the team plan launches, and we do not give it to third parties. There is no web page or API that can read the list; only the operator can export it. Joining twice with the same address does not create a second entry.

## Third-party services

| Service | What it does for gtree | What it can see |
|---|---|---|
| Cloudflare | Runs the download server and its database (D1), Web Analytics, DNS, and forwards email sent to `support@dobbylab.com` | Requests to `gtree-dl.dobbylab.com`, website visits (Web Analytics), early-bird sign-ups, emails to support |
| GitHub | Hosts the website (GitHub Pages) and the release files | Website visits; requests that fall back directly to GitHub |
| Anthropic | Provides Claude Code, which you install and sign in to yourself | Whatever you share with Claude Code, under Anthropic's terms. DobbyLab is not involved |
| OpenAI | Provides Codex, which you install and sign in to yourself | Whatever you share with Codex, under OpenAI's terms. DobbyLab is not involved |

Each service handles data under its own privacy policy.

## How long we keep data

- **Daily counts and per-device rows** in our Cloudflare D1 database: there is currently no automatic deletion. They are kept until we delete them.
- **Early-bird list entries**: kept until the team plan launches and we no longer need them, or until you ask us to delete yours.
- **Cloudflare Web Analytics, Cloudflare infrastructure logs and GitHub Pages logs**: kept according to Cloudflare's and GitHub's own policies.
- **Data on your Mac**: kept until you delete it or uninstall gtree.

## Your choices and rights

- **Statistics**: turn them off at any time, as described above.
- **Early-bird list**: email support@dobbylab.com from the address you signed up with, and we will delete it.
- **Device ID**: the ID is random and not linked to you, so we cannot find "your" data on our own. If you want its records deleted, send us the contents of `~/.gtree/device-id`. Deleting that file makes gtree generate a new ID next time.

## Children

gtree is a developer tool and is not directed at children under 13. We do not knowingly collect personal information from children. If you believe a child has joined the early-bird list, contact us and we will delete the entry.

## Changes to this policy

If what gtree collects changes, we will update this page and the date at the top before the change ships. Data collection in the app will continue to require that you have been notified first.

## Contact

- Email: support@dobbylab.com
- X: [@dobbylabhq](https://x.com/dobbylabhq)
- Website: https://gtree.dobbylab.com
