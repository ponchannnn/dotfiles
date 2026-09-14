# 必須指定ツールの設定詳細 (tmux / git / gh / ghq)

「必須。設定も欲しい/踏襲したい」と指定されたtmux・git・gh・ghqの実装リファレンス。
参照元: https://github.com/ogadra/dotfiles

---

## tmux

参照元: `home-manager/common/cli/tmux/default.nix`

### 今の `~/.config/tmux/tmux.conf` との違い

今の設定(mouse on, スクロールでコピーモードに入る, **prefix=C-a**, 256色, ステータスライン色変更,
prefix入力中に色変更)と比べると、ogadraさんの設定は**prefixがC-q**で、機能的にかなり作り込まれている。
そのまま丸ごと入れると今の設定と衝突する箇所があるので、要点を分けて書く。

### 衝突する/選択が必要な項目

| 項目 | 今の設定 | ogadraさんの設定 |
|---|---|---|
| prefix | `C-a` | `C-q`(WezTerm側もこれに合わせてCtrl+Qをtmuxへ送るバインドをしている) |
| ステータスライン色 | 独自のカスタム色 | オレンジ×黒のNERV風パレット(WezTermと統一されたテーマ) |
| スクロールでコピーモード | 独自バインド(`WheelUpPane`) | 同様の機能はないが、コピーモード中のホイール量を2行に制限するバインドあり |

前回WezTermのtmux連携を実装した際、**今のtmux.confのprefix(C-a)に合わせてWezTermのショートカットを
調整した**ため、ogadraさんのprefix(C-q)をそのまま持ち込むなら、WezTerm側のtmux連携キーも
再度C-qに合わせ直す必要がある(逆に、prefixはC-aのままでステータスラインの見た目だけ移植する、
という選択肢もある)。

### 今の設定にない追加要素(そのまま追加できるもの)

- `mouse = true` は今と同じなので問題なし
- `baseIndex = 1`: ウィンドウ番号を0からではなく1から開始
- `escapeTime = 0`: Escキー入力の遅延をゼロに(vim等でEscの反応を早くする)
- `keyMode = "emacs"`: コマンドライン編集のキー操作をemacs風に
- `historyLimit = 50000`: スクロールバック行数を5万行に拡張
- `terminal = "tmux-256color"` + `terminal-overrides ",*256col*:Tc"`: 256色・truecolor対応
- `pane-base-index = 1`: ペイン番号も1から開始
- コピーモード中のマウスホイールを2行スクロールに制限(デフォルトの5行だと速すぎる、という調整)
- マウスドラッグでの範囲選択後、選択状態を維持したままにする(`copy-selection-no-clear`。通常はドラッグ終了と同時にコピー&選択解除されるが、それを防ぐ)
- `set-environment -g CLAUDE_CODE_TMUX_TRUECOLOR 1`: **Claude CodeはtmuxのTMUX環境変数を検知すると自動で色深度を256色に落とす仕様があり、それを回避してtruecolorを維持するための環境変数**。Claude Codeをtmux内で使うなら有用
- ウィンドウ名をカレントディレクトリ(gitリポジトリなら「リポジトリ名/相対パス」)に自動リネームするfish関数。**WezTermのタブタイトルと全く同じロジック**(既にwezterm.luaに実装済みのget_display_path相当)をtmuxのウィンドウ名にも適用している
- 新しいOSウィンドウを開いたら自動でtmuxセッションにアタッチする(ただしtmux内・Claude Code実行中は除く)fish設定

### ステータスライン(NERV風)の構成

- 常時は左側に「TERMINAL」ラベルのみを表示する待機状態
- prefixキーを押している間は、画面幅に応じて全キーヒント/短縮キーヒントをステータスバー全体に表示(`c:window w:閉じる n/p:前後 %:左右 ":上下 o:pane z:zoom [:copy ]:貼付 =:履歴 s:session d:detach`)
- 右側には現在のディレクトリのgitブランチ名(gitリポジトリ内の時だけ)、プロファイル名、時刻を表示
- タブ(ウィンドウ)表示はWezTermと同じ三角形の区切り記号(Powerline風)を使った見た目
- 色はWezTermのcolor.nixと同じ配色コード(colour16=orange, colour17=black, colour18=deepBlack, colour19=dimOrange)を使うことで**tmuxとWezTermの見た目を完全に統一**している

### prefix経由のキー割り当て(tmux.conf内, WezTerm側から呼ばれる想定)

```
bind c new-window -c "#{pane_current_path}"   # prefix + c: 新規ウィンドウ(カレントディレクトリ継承)
bind % split-window -h -c "#{pane_current_path}"  # prefix + %: ペイン分割
bind w kill-window                             # prefix + w: ウィンドウを閉じる
bind n next-window                             # prefix + n: 次のウィンドウ
bind p previous-window                         # prefix + p: 前のウィンドウ
```

これは前回実装したWezTerm側の `Cmd+Shift+T`(tmux new window) / `Cmd+D`(split) 等が
実際にtmux側で何を実行しているかの定義そのもの。今のtmux.confにはこのbind定義がないので、
WezTermからのショートカットを活かすならこの部分は追加が必要。

---

## git

参照元: `home-manager/common/cli/git/default.nix`, `ignores.nix`, `allowed_signers`

### 主要設定

```
init.defaultBranch = "main"
push.default = "current"       # git push だけでカレントブランチを対応するリモートブランチにpush
ghq.root = "~/codes"           # ghqでcloneしたリポジトリの置き場所
url."git@github.com:".insteadOf = "https://github.com/"  # https://github.com/... へのアクセスを全部SSH経由に自動変換
```

### コミット署名(SSH署名)

```
signing.format = "ssh"
signing.key = "~/.ssh/id_ed25519.pub"
signing.signByDefault = true    # 全コミットに自動でSSH署名を付与
gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers"
```

GPGではなく**SSH鍵を使ったコミット署名**(Gitが比較的新しくサポートした方式)。`allowed_signers`
ファイルには「このメールアドレスはこの公開鍵で署名する」という対応表を1行で記載
(`<email> ssh-ed25519 <公開鍵>`)。GitHub上でコミットに"Verified"バッジを付けるのに使う。
**採用する場合は自分のSSH公開鍵とメールアドレスに差し替える必要がある**(ogadraさんの鍵をそのまま
使うことはできない/意味がない)。

### グローバルgitignore (`ignores.nix`)

カテゴリ別に整理されたグローバル除外パターン:

- **OS別ゴミファイル**: macOSの`.DS_Store`系、Windowsの`Thumbs.db`系、WSLの`*Zone.Identifier`
- **エディタ**: `.vscode/`
- **ログ・一時ファイル**: `*.log`, `*.tmp`, `*.temp`
- **ビルド成果物**: `dist/`, `build/`, `out/`, `node_modules/`
- **環境変数・秘密情報**: `.env`, `.env.*`, `.secrets`, `*.key`, `*.pem`, `*.crt`
- **Claude Code設定**: `**/.claude/settings.local.json`, `**/CLAUDE.local.md`(ローカル専用の個人設定はコミットしない)
- **MCP設定**: `.playwright-mcp/*`
- **Nix関連**: `.direnv/`
- **takt(未導入ツール)関連**: `.takt/runs`

これは「個々のリポジトリの`.gitignore`に書かなくても、どのマシンのどのリポジトリでも
自動的に無視されるファイルパターン」をグローバル設定として一元管理している。特に
`.claude/settings.local.json`や`.env`系を確実に除外する運用は、秘密情報の誤コミット防止として
今回の環境にもそのまま持ち込む価値がある。

---

## gh (GitHub CLI)

参照元: `home-manager/common/cli/gh/default.nix`

```
programs.gh.enable = true;
programs.gh.extensions = [ pkgs.gh-stack ];
```

拡張機能として `gh-stack`(スタックされたPR、つまり複数のPRを積み重ねて依存関係を管理する
ワークフロー支援ツール)を1つ入れているだけ。それ以外のカスタム設定(エイリアス等)はなし。

---

## ghq

参照元: `home-manager/common/cli/ghq/default.nix`

```
home.packages = [ pkgs.ghq ];
```

インストールのみで、ghq自体のカスタム設定はここにはない(リポジトリの置き場所である
`ghq.root = "~/codes"` は前述のgit設定側で指定されている)。ghqは「`ghq get <repo>`で
`~/codes/github.com/<owner>/<repo>`のような統一された階層にリポジトリをcloneしてくれるツール」。
前述のAIエージェント暴走防止ガードが`git clone`や`gh repo clone`を禁止してghq経由を強制しているのは、
この「リポジトリの置き場所を一元管理する」運用を徹底するため。
