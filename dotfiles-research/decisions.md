# 決定事項チェックリスト (used-apps.md レビュー結果)

ユーザーがused-apps.mdをレビューして表明した決定事項の書き起こし。実装時のチェックリストとして使う。
詳細説明の参照先は同じ `dotfiles-research/` 配下の各ファイル。

## アプリ

- [ ] **Chrome**: Macなら導入
- [x] ~~Emacs~~: 不要
- [ ] **VSCode**: Macなら導入。キーバインドは全部踏襲、設定値も決定済み → [vscode-keybindings.md](./vscode-keybindings.md)
  - 拡張機能はogadraさんの4つ(copilot/go/direnv/spell-checker)とこのMacの現在の84個を比較表示済み。**どれを入れるかはまだ未回答、判断待ち**
- [x] **Raycast**: Macなら導入。「ABCに強制」の説明済み(起動時に入力ソースを英数に強制する設定) → [used-apps.md](./used-apps.md#raycast)。**決定: ABC設定含め全部踏襲**
- [ ] **Fish**: 現時点ではzshを維持、fish不採用。zsh/fishの違いをmdにまとめ済み → [used-apps.md](./used-apps.md#zsh-vs-fish乗り換えの判断材料)
- [ ] **Tmux**: 必須。設定も導入したい → [essential-cli-configs.md](./essential-cli-configs.md#tmux)(実装未着手)
- [ ] **Git**: 必須。設定も踏襲したい → [essential-cli-configs.md](./essential-cli-configs.md#git)(実装未着手)
- [ ] **Gh**: 必須。設定も必須 → [essential-cli-configs.md](./essential-cli-configs.md#gh-github-cli)(実装未着手)
- [ ] **Ghq**: 必須 → [essential-cli-configs.md](./essential-cli-configs.md#ghq)(実装未着手)
- [x] **fzf/bat/jq/nano/tree/direnv/unzip**: **実装済み**。Homebrewでインストール、`.zshrc`にfzf/direnv連携を追加、`bootstrap.sh`にも追加(Mac/Ubuntu両方) → [used-apps.md](./used-apps.md#fzf--bat--jq--nano--tree--direnv--unzip)
- [ ] **Claude Code**: 必須。踏襲。**自動圧縮(auto-compact)はON**(ogadraさんはOFF)、それ以外はogadraさんの設定を踏襲(実装未着手)
- [ ] **Status line**: 必須(実装未着手)
- [ ] **themes/nerv.json**: 必須。説明済み(NERV=エヴァンゲリオン風オレンジ×黒のANSIカラーテーマ、WezTermの配色と同系統) → [used-apps.md](./used-apps.md#themesnervjson-とは)
- [ ] **CLAUDE.md**: 必須(実装未着手)
- [x] **Skills**: 一旦必須、**内容は現状維持のまま様子見**。absolute-rules/pr-review/cascade-merge の説明済み → [used-apps.md](./used-apps.md#skills-カスタムスキール--一旦必須内容は現状維持)
- [x] **readable-writing (Skillの一つ)**: **決定: 踏襲(導入)**。中身の説明も済み(日英対応の文章作法レビュー&自動修正、立場/主体/箇条書き/構成/修辞/語彙/記号の7観点)(実装未着手)
- [ ] **AIエージェント暴走防止ガード**: 説明済み(sudo/find -delete/xargs rm/一括git add/--no-verify/git clone直打ち/デフォルトブランチ直push を機械的にブロックするPreToolUseフック群) → [used-apps.md](./used-apps.md#aiエージェントの暴走防止ガード-home-managercommonmodulesllm-agent--踏襲予定)。**決定: 踏襲するが、Claude Code自体の権限挙動を変える変更なので実装は明示的なGOをもらうまで保留**

## macOS設定

- [x] **Dock**: 現在の自分の設定を維持。**アイコンサイズだけ39→40に変更、適用済み** → [mac-current-settings.md](./mac-current-settings.md#dock)
- [x] **Finder**: 拡張子常時表示 + 隠しファイル常時表示 → 既に両方有効、追加作業なし
- [ ] **ホットコーナー**: 無効化(実装未着手)
- [ ] **キーボード**: ogadraさんの設定を踏襲(実装未着手)
- [ ] **メニューバー**: ogadraさんの設定を踏襲(実装未着手)
- [ ] **コントロールセンター**: 基本踏襲、ただしNow Playingは表示のままにする(実装未着手)
- [ ] **Activity Monitor**: ogadraさんの設定を踏襲(実装未着手)
- [x] **ログイン画面**: 決定確定。ゲストログイン無効化 / ユーザー一覧(フルネーム入力欄方式)は今のままでOK / カスタムメッセージなし / シャットダウン・スリープ・再起動ボタンは有効のまま。**実装は保留**(管理者権限で`/Library/Preferences`を書き換える必要があり、影響範囲がユーザー領域を超えるため明示的なGOをもらってから)
- [ ] **スクリーンセーバー**: ogadraさんの設定を踏襲(実装未着手)
- [x] **ソフトウェアアップデート**: 変更しない(現状維持)
- [ ] **Spaces**: 説明済み(Mission Controlの仮想デスクトップ機能。ディスプレイごとに独立したSpace構成にするかどうかの設定) → [used-apps.md](./used-apps.md#macos-システム設定-darwin-nix-darwin経由)。**採用判断は保留**
- [ ] **Window Manager**: 表示関連の設定を採用(Stage Manager無効、デスクトップアイコン/ウィジェット非表示)(実装未着手)
- [x] **入力ソース**: 変更しない(現状維持)。macSKKは未導入
- [ ] **Launch Services**: 踏襲(ダウンロードアプリの検疫警告=Gatekeeperの確認ダイアログを無効化)。説明済み(実装未着手)
- [x] **ユニバーサルアクセス**: 変更しない(現状維持)
- [x] **マウス/トラックパッド**: 自分の現在の設定を維持。**トラックパッドの追跡速度は既に最大(3)** と判明、マウス側は値未設定(実機未確認)。詳細と後日対応方針を記録済み → [mac-current-settings.md](./mac-current-settings.md#トラックパッド--マウスのトラッキング速度-後から対処するための保留事項)

## Linux設定

すべて内容の説明待ち → [explanations.md](./explanations.md) の該当セクション参照(現状 Linux関連と「その他」セクションのみ残っている)。採用判断は保留。

- [ ] デスクトップ環境(KDE Plasma) → [explanations.md](./explanations.md#linux-デスクトップ環境kde-plasmaとは)
- [ ] フォント(BIZ UDPゴシック案) → [explanations.md](./explanations.md#linux-フォント設定)
- [ ] ロケール → [explanations.md](./explanations.md#linux-ロケール)
- [ ] オーディオ(機種依存のため移植不要と判明) → [explanations.md](./explanations.md#linux-オーディオ)
- [ ] KDE設定 → [explanations.md](./explanations.md#linux-kde設定)
- [ ] クリップボード履歴 → [explanations.md](./explanations.md#linux-クリップボード履歴)
- [ ] ランチャー(wofi/ulauncher) → [explanations.md](./explanations.md#linux-ランチャー)
- [ ] 残り全部(xremap/mouse/klipper/kwinショートカット/initスクリプト) → [explanations.md](./explanations.md#linux-残り全部xremap--mouse--klipper--kwinショートカット--initスクリプト)

## その他(ルート直下ファイル)

一旦全て内容確認済み → [explanations.md](./explanations.md#その他ルート直下ファイル) / [used-apps.md](./used-apps.md#その他-ルート直下ファイル--内容確認済み採用判断はこれから)。採用判断はこれから。

- [ ] README.md / CLAUDE.md(ルート)
- [ ] Makefile / flake.nix(Nix前提、今回は非採用が濃厚)
- [ ] lefthook.yaml(gitフック管理)
- [ ] renovate.json + `.github/workflows/*`(依存更新Bot、個人dotfilesに必要か要検討)
- [ ] data/gitleaks.toml.sample / data/path.yaml.sample
- [ ] .chezmoiignore(レガシー、移植不要と判明)
- [ ] .envrc(Nix前提、今回は非採用が濃厚)

## メモ: ファイル整理の経緯

- `explanations.md`は途中まで読んで該当セクションをユーザー自身が削除済み(Raycast/Fish/fzf〜unzip/Claude Code/macOSログイン画面・Spaces・Launch Servicesのセクションは消去済み)。残りはLinux関連と「その他」のみ。次回そのまま確認予定なので**このファイルには触れていない**
- `used-apps.md`・`mac-current-settings.md`・`vscode-keybindings.md`は今回全面的に書き直した(不要になった内容を削り、決定事項・実装状況を反映)
- `unused-apps.md` / `essential-cli-configs.md` / このファイルは内容そのままでdotfilesリポジトリにpush済み
