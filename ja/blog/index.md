# ブログ

複数のエージェントと同時にコードを書くための実践的な方法と、gtree の各機能の使いどころを紹介します。

- [gtree が Electron を使わない理由 — 24 MB、0.2 秒でウィンドウ表示](https://gtree.dobbylab.com/ja/blog/gtree-native-app-not-electron/) (2026-10-25) — gtree は Rust で書かれ、画面は Zed エディタの GPU 描画フレームワーク GPUI で描いています。ブラウザも Node も同梱していません。ネイティブで何が得られるのか、実測値と測り方をまとめました。
- [Claude Code の変更を元に戻す方法 — 閉じたセッションのターンも復元](https://gtree.dobbylab.com/ja/blog/undo-claude-code-changes/) (2026-10-22) — AI エージェントが 3 ターン前に何かを壊した? git、Claude Code の /rewind、そして gtree の「AI の各ターン」の 3 つの取り消し方を比較します。gtree ならどのターンのファイルも復元でき、新しいセッションは前回の続きを覚えています。
- [2 つの AI エージェントが同じファイルを編集するとき — 互いに上書きさせない方法](https://gtree.dobbylab.com/ja/blog/ai-agents-editing-same-file/) (2026-10-19) — Claude Code や Codex を並列で動かすとき、2 つの AI エージェントが同じファイルを編集していることにどう気づくか。git での確認コマンドと、エージェント同士が声をかけ合って順番を決める gtree の仕組みを解説します。
- [Claude Code の承認待ちにすぐ気づく方法 — 通知と状態の見える化](https://gtree.dobbylab.com/ja/blog/claude-code-waiting-for-approval-notifications/) (2026-10-13) — Claude Code は許可が必要になると止まって待ち続けます。Notification hook で通知を出す方法と、複数並列でもどのセッションが待っているかをひと目で把握する方法を解説します。
- [Claude Code を複数並列で動かす方法 — git worktree 入門](https://gtree.dobbylab.com/ja/blog/run-multiple-claude-code-git-worktree/) (2026-10-10) — 複数の Claude Code を同じリポジトリで並列に動かすなら、セッションごとに git worktree を用意するのが確実です。実際のコマンド、つまずきやすい点、手間を省く方法をまとめました。
