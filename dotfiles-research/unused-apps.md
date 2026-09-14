# 使っていないアプリの概要と設定 (ogadra/dotfiles より)

このドキュメントの目的: [ogadra/dotfiles](https://github.com/ogadra/dotfiles)にあるが、自分は現状使っていないアプリ・ツール。「そもそも何なのか」の説明と、ogadraさんがどう設定しているかを軽くまとめた。興味が湧いたものがあれば`used-apps.md`側に移して詳しく調べる、くらいの温度感で見てほしい。

---

## GUIアプリ

### 1Password
パスワードマネージャー。ブラウザ拡張・アプリ連携でログイン情報やSSHキーを一元管理する定番ツール。CLI版(`_1password-cli`)も併用し、GUIアプリ本体をNixストアから`/Applications`にコピーするインストール方式。

### AltTab
macOS標準の`Cmd+Tab`をWindows風の「全ウィンドウのサムネイル一覧」に変える無料ウィンドウ切替アプリ。ogadraさんは配布元の公式ビルド(Developer ID署名済み)を使用——nixpkgs版は再ビルドのたびに署名が変わり、画面収録権限(TCC)が毎回失効するのを避けるための工夫。サムネイル配置・パネルサイズ・表示Space・Finder/Mailを例外扱いにする等、細かく`defaults`調整。

### Brave
プライバシー重視の広告ブロック内蔵ブラウザ(Chromiumベース)。パッケージ導入のみで設定カスタマイズなし。

### Karabiner-Elements
macOSのキーボードカスタマイズの定番アプリ。低レベルでキーコードを書き換えられる。ogadraさんは内蔵キーボードで**Caps LockとControlを入れ替え、さらにCommandとOptionも入れ替え**、加えてVSCode/WezTerm以外のアプリでEmacs風キーバインド(Ctrl+F/B/N/P等でカーソル移動)を有効化する設定を組んでいる。

### macSKK
macOS用のネイティブSKK方式日本語入力メソッド(IME)。SKK辞書(`SKK-JISYO.L`)をEUC-JPからUTF-8に変換して同梱し、Input Methodsとして`~/Library/Input Methods/`に配置(sudo不要)。起動直後は自動でASCII(直接入力)モードに切り替えるスクリプト付き。

### mos
Magic Mouse等のスクロールを「なめらかスクロール」に変えるユーティリティ。スクロール速度・アニメーション時間・ステップ量などを`defaults`で細かく調整。配布はSparkle形式のzip。

### OBS Studio
配信・録画の定番オープンソースソフト。パッケージ導入のみ。

### Shottr
高機能スクリーンショットツール(スクロールキャプチャ、簡易編集、OCR等)。DMGから直接インストールする方式で設定カスタマイズはなし。

### Spotify
音楽ストリーミングアプリ。パッケージ導入のみ。

---

## LLMエージェント関連

### ccusage
Claude Codeの利用量・コストを集計するCLIツール。`llm-agents.nix`という自作flakeからパッケージを取得。前述のClaude Codeステータスライン(当日/当月コスト表示)の裏側で使われている。

### Codex (OpenAI Codex CLI)
ClaudeCode相当のOpenAI製コーディングエージェントCLI。ogadraさんは独自にラップして`--profile ogadra`を自動付与、Claude Codeと同じgit/gh暴走防止ガードスクリプト(`pre-bash.sh`等)を`/etc/codex/hooks/`経由で共有している。設定ファイル(`ogadra.config.toml`)では日本語での応答を指定、`sandbox_mode = "danger-full-access"`(サンドボックスをほぼ無効化)、独自のステータスライン(コンテキスト使用率・レート制限・コスト表示)などClaude Code設定と対になっている。`AGENTS.md`はClaude Codeの`CLAUDE.md`と同内容(git運用ルール、コメント方針)をCodex向けに複製したもの。`default.rules`は`docker`・`gh issue/pr`・`git add/commit/fetch/push`・`nix`系コマンドを許可リスト化する権限ルール。

### gitleaks
Gitリポジトリ内のシークレット(APIキー、パスワード等)混入を検出するスキャナー。`lefthook`のpre-commitフックから呼ばれ、コミット前に必ずスキャンが走る構成。

---

## CLIツール

### gnumake
GNU製の`make`コマンド。ogadraさんのリポジトリ自体が`make switch`/`make update`で運用されているため、その実行環境として導入。

### gomi
「安全なrm」を提供するCLIツール。`rm`で消したファイルを即削除せずゴミ箱ディレクトリ(`~/.gomi`)に退避し、誤削除を`gomi`コマンドで復元できる。zsh/fishの両方で`rm`をこれにオーバーライドしている。

### hunk
Git向けのステージング支援CLI(diffをハンク単位で対話的にstage/unstageできるツール)。パッケージ導入のみで設定なし。

### mpv
軽量な動画/音声プレイヤーCLI。ogadraさんの環境では**メディア再生用途というより「通知音を鳴らすためのバックエンド」**として多用されている(Claude Code/Codexの通知音、fishの`done`関数、tmux操作音など)。

### starship
プロンプトカスタマイズツール(シェル非依存でZsh/Fish/Bash等どこでも同じ見た目のプロンプトを出せる)。ogadraさんは有効化しているが、設定はごく小さく「ユーザー名セグメント(黄地に黒文字)+ディレクトリセグメント」のみのシンプルな2segment構成。fishの複雑なプロンプトロジックを書かずに済ませるための最小限の利用。

### takt
ogadraさん自作のNix flake(`nix-takt`)から導入されるツール。設定は`language: ja` / `provider: claude`の2行のみで、具体的に何をするツールかは今回読んだ範囲の設定ファイルからは特定できなかった(リポジトリ名から推測すると、Claude系エージェントのオーケストレーション/実行管理ツールの可能性がある)。気になる場合は[nix-takt](https://github.com/ogadra/nix-takt)本体を見る必要がある。
