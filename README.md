# dotfiles

Mac / Ubuntu で共有する設定ファイル一式。シンボリックリンクは使わず、
`$HOME` を work-tree とした bare git リポジトリでバージョン管理する。

## 新規マシンでの復元

```bash
curl -fsSL https://raw.githubusercontent.com/ponchannnn/dotfiles/main/bootstrap.sh | bash
```

これだけで以下が行われる:

- OS 判定 (`Darwin` / `Linux`) して必要パッケージをインストール
- `$HOME/.dotfiles` に bare リポジトリを clone
- 既存ファイルと衝突する場合は `~/.dotfiles-backup/<timestamp>/` に退避してから checkout
- `packages/` 以下のパッケージリストがあれば追加インストール
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

```bash
./export-packages.sh
```

- Ubuntu: `packages/apt-packages.txt`
- Mac: `packages/Brewfile`

を生成する。生成後は `dotfiles add packages/` でコミットする。

## 管理対象ファイル

- `.zshrc`
- `.gitconfig`
- `.vimrc`
- `.config/nvim/`

対象は今後相談の上で追加・削除する。

## 注意

`~/.ssh`, `~/.aws` などの秘密鍵・トークン類は絶対にこのリポジトリで
管理しない（`.gitignore` の許可リストにも追加しない）。
