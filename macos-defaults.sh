#!/usr/bin/env bash
# Apply this Mac's keyboard/mouse/trackpad/cursor/appearance/Dock/Siri/Finder
# preferences via `defaults write`.
# Called from bootstrap.sh on macOS when --macos-defaults is passed; safe to re-run.
#
# 対象外にしたもの(理由は README / 会話ログ参照):
# - 通知(com.apple.ncprefs): アプリごとのコード署名要件を含むバイナリBLOBで再現不可
# - メニューバーのアイコン表示/位置(com.apple.controlcenter): バイナリBLOB+座標値で再現不可
# - キーボードショートカット(com.apple.symbolichotkeys): 100項目超の巨大構造、壊れた時の被害が大きい
# - 入力ソース(日本語ローマ字など): 配列構造で複雑なため、新規マシンでは
#   システム設定 > キーボード > 入力ソース から手動追加を推奨(macOS標準搭載なので数十秒で済む)
set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
    echo "macos-defaults.sh is macOS-only, skipping." >&2
    exit 0
fi

# --- キーボード ---
defaults write -g KeyRepeat -float 2
defaults write -g InitialKeyRepeat -float 25
defaults write -g AppleKeyboardUIMode -int 0
defaults write -g com.apple.keyboard.fnState -bool true
defaults write -g NSAutomaticCapitalizationEnabled -bool true
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool true

# --- マウス ---
defaults write -g com.apple.mouse.scaling -float 1
defaults write -g com.apple.swipescrolldirection -bool true

# --- トラックパッド ---
defaults write -g com.apple.trackpad.scaling -float 3
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad DragLock -int 0

# --- カーソル(ポインタの塗り色/縁取り色。NERVテーマのオレンジに合わせたカスタム色) ---
# 注: com.apple.universalaccess はmacOSのTCC保護下にあり、このスクリプトを実行する
#     ターミナルに「アクセシビリティ」権限が許可されていないと defaults write が失敗する。
#     失敗してもキーボード/マウス/トラックパッドの設定は適用済みなので、続行して警告のみ出す。
cursor_ok=true
defaults write com.apple.universalaccess cursorIsCustomized -bool true 2>/dev/null || cursor_ok=false
defaults write com.apple.universalaccess cursorFill -dict red 1 green 0.1491314173 blue 0 alpha 1 2>/dev/null || cursor_ok=false
defaults write com.apple.universalaccess cursorOutline -dict red 1 green 1 blue 1 alpha 1 2>/dev/null || cursor_ok=false

if [ "$cursor_ok" = false ]; then
    echo "WARN: カーソル色の設定に失敗しました。システム設定 > プライバシーとセキュリティ > アクセシビリティ でこのターミナルを許可してから再実行するか、システム設定アプリの「ポインタ」から手動で設定してください。" >&2
fi

# --- 外観 ---
defaults write -g AppleInterfaceStyle -string Dark

# --- Dock ---
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

# --- Siri ---
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false

# --- 一般 (Finder) ---
defaults write -g AppleShowAllExtensions -bool true
defaults write -g AppleMiniaturizeOnDoubleClick -bool false

killall cfprefsd >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
echo "Applied macOS keyboard/mouse/trackpad/appearance/Dock/Siri/Finder defaults (some changes may need logout/login to fully take effect)."
echo "NOTE: 日本語(ローマ字)入力ソースは未適用です。システム設定 > キーボード > 入力ソース から手動で追加してください。"
