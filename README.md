# dotfiles

Mac / Ubuntu で共有する設定ファイル一式。シンボリックリンクは使わず、
`$HOME` を work-tree とした bare git リポジトリでバージョン管理する。

## 新規マシンでの復元

```bash
curl -fsSL https://raw.githubusercontent.com/ponchannnn/dotfiles/main/bootstrap.sh | bash
```

これだけで以下が行われる:

- OS 判定 (`Darwin` / `Linux`) して最低限のツール(Mac: Homebrew本体 / Linux: apt決め打ちリスト)をインストール
- `$HOME/.dotfiles` に bare リポジトリを clone
- 既存ファイルと衝突する場合は `~/.dotfiles-backup/<timestamp>/` に退避してから checkout
- `packages/` 以下のパッケージリストがあれば追加インストール
  (Mac は `packages/Brewfile` から全パッケージをこのステップで入れる。Linux は現状未整備)
- デフォルトシェルを zsh に変更

## 管理方法

`.zshrc` に以下のエイリアスを設定済み:

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

以後は `$HOME` 内で通常の git コマンドを `dotfiles` 経由で使う。

```bash
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "update vimrc"
dotfiles push
```

新しく管理対象に加えたいファイルは、まず `~/.gitignore` に `!` で許可
エントリを追加してから `dotfiles add` する（デフォルトは全ファイル無視）。

## パッケージリストの更新

- **Ubuntu**: `./export-packages.sh` で `packages/apt-packages.txt` を生成し、
  `dotfiles add packages/` でコミットする。
- **Mac**: `packages/Brewfile` は最小構成を手動管理する方針。新しいパッケージを増やす時は
  `brew install <pkg>` してから `packages/Brewfile` に1行手で追記する。
  `./export-packages.sh` (`brew bundle dump`) は今入っている全パッケージで上書きしてしまうため、
  **Macでは使わないこと**。

## 管理対象ファイル

- `.zshrc`
- `.zprofile` / `.zshenv`(zshログイン時のPATH設定。cargo/homebrew/python等)
- `.gitconfig`
- `.vimrc`
- `CLAUDE.md`
- `.githooks/`(pre-commitでgitleaksによるシークレットスキャンを実行。`core.hooksPath`で有効化)
- `.config/wezterm/`
- `.config/tmux/`
- `.config/nvim/`(現状未使用、許可枠のみ)
- `.claude/`(`settings.json`, `CLAUDE.md`, `statusline-command.sh`, `themes/nerv.json`のみ。
  会話履歴・セッション・キャッシュ等は`.gitignore`で除外)
- `Library/Application Support/Code/User/`(VSCodeの`settings.json`, `keybindings.json`, `snippets/`のみ。
  `workspaceStorage`/`extensions`/`sync`等の状態・キャッシュ・拡張機能本体は`.gitignore`で除外)

対象は今後相談の上で追加・削除する。`dotfiles-research/` はローカルの調査・検討メモ置き場で、
`.gitignore` で明示的に除外しており、このリポジトリにはアップロードしない。

## 注意

`~/.ssh`, `~/.aws` などの秘密鍵・トークン類は絶対にこのリポジトリで
管理しない（`.gitignore` の許可リストにも追加しない）。
