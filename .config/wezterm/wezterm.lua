local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

-- 日本語の一部が豆腐(四角)になる問題への対応。
-- config.font を指定しないと JetBrains Mono -> Noto Color Emoji -> Symbols Nerd Font Mono
-- しかフォールバックに入らず、CJKはmacOSの自動代替(Apple SD Gothic Neoの内部UI用フォント)
-- に落ちてグリフ欠けが起きるため、日本語フォントを明示的にフォールバックへ加える。
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Hiragino Sans",
  "BIZ UDGothic",
  "Noto Color Emoji",
  "Symbols Nerd Font Mono",
})
config.font_size = 12.0
config.use_ime = true

-- カーソルの点滅アニメーション。ogadra/dotfilesのcolor.nixを踏襲
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cursor_thickness = 2

----------------------------------------------------
-- Colors (ogadra/dotfiles の NERV HUD 風オレンジパレットを移植)
-- https://github.com/ogadra/dotfiles/blob/main/home-manager/common/apps/terminal/wezterm/color.nix
----------------------------------------------------
local ORANGE = "#ff8a25"
local BLACK = "#1a1a1a"
local DEEP_BLACK = "#0a0a0a"
local DIM_ORANGE = "#935c37"
local WHITE = "#ffffff"
local GREEN = "#25ef25"
local RED = "#ef2525"
local PURPLE = "#b837ff"
local TEAL = "#37dddd"

config.colors = {
  foreground = ORANGE,
  background = "#000000",
  cursor_bg = ORANGE,
  cursor_fg = DEEP_BLACK,
  selection_bg = ORANGE,
  selection_fg = DEEP_BLACK,
  ansi = { BLACK, RED, GREEN, ORANGE, "#7878ff", PURPLE, TEAL, "#cacaca" },
  brights = { "#404040", "#ff3737", "#37ff37", "#ffa625", "#9393ff", "#dd6eff", "#4affff", "#ffffff" },
  indexed = {
    [16] = ORANGE,
    [17] = BLACK,
    [18] = DEEP_BLACK,
    [19] = DIM_ORANGE,
    [20] = "#0c3a0c",
    [21] = "#4a1010",
    [22] = "#1a6a1a",
    [23] = "#8a1a1a",
    [24] = "#d77757",
    [25] = "#f59575",
    [26] = "#ff6933",
    [27] = "#ef5825",
    [28] = "#ffed26",
    [29] = "#c46686",
  },
  tab_bar = {
    background = ORANGE,
    -- アクティブタブはバーと同色(オレンジ)に溶け込ませ、文字を暗色で抜く
    active_tab = { bg_color = ORANGE, fg_color = DEEP_BLACK },
    inactive_tab = { bg_color = DEEP_BLACK, fg_color = DIM_ORANGE },
    inactive_tab_hover = { bg_color = DIM_ORANGE, fg_color = WHITE },
  },
}

----------------------------------------------------
-- Background: plus-pattern.png (398px単位でリピート、四隅にコーナーマーク)
-- https://github.com/ogadra/dotfiles/blob/main/home-manager/common/apps/terminal/wezterm/background.nix
----------------------------------------------------
config.window_background_opacity = 0.9
config.macos_window_background_blur = 12
config.background = {
  {
    source = { File = wezterm.config_dir .. "/assets/plus-pattern.png" },
    repeat_x = "Repeat",
    repeat_y = "Repeat",
    width = 398,
    height = 398,
  },
}

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示 + ウィンドウを閉じる時の確認をスキップ
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は表示
config.hide_tab_bar_if_only_one_tab =false 
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

----------------------------------------------------
-- Focus: 非アクティブウィンドウの見た目を変える
-- https://github.com/ogadra/dotfiles/blob/main/home-manager/common/apps/terminal/wezterm/focus.nix
----------------------------------------------------
local FOCUSED_BORDER_WIDTH = "6px"
local UNFOCUSED_BORDER_WIDTH = "4px"
local UNFOCUSED_BORDER_COLOR = "#3a3a3a"
local UNFOCUSED_OPACITY = 0.5

-- 非アクティブ時は少しくすんだ琥珀色パレットに切り替える
local UNFOCUSED_COLORS = {
  foreground = "#caa153",
  background = "#000000",
  cursor_bg = "#caa153",
  cursor_fg = "#0a0a0a",
  selection_bg = "#caa153",
  selection_fg = "#0a0a0a",
  ansi = { "#1a1a1a", "#b85443", "#43b153", "#caa153", "#6655ca", "#b243c1", "#4397a6", "#a6a6a6" },
  brights = { "#3a3a3a", "#dd6a55", "#55d469", "#e6b65c", "#826eef", "#d65ce6", "#55b9ca", "#cacaca" },
  indexed = {
    [16] = "#caa153",
    [17] = "#1a1a1a",
    [18] = "#0a0a0a",
    [19] = "#8c6b2e",
    [20] = "#0c3a13",
    [21] = "#4a1910",
    [22] = "#1a6a26",
    [23] = "#8a2b1a",
    [24] = "#bb784c",
    [25] = "#d59266",
    [26] = "#de762c",
    [27] = "#d06620",
    [28] = "#d1de21",
    [29] = "#ab5969",
  },
  tab_bar = {
    background = "#caa153",
    active_tab = { bg_color = "#1a1a1a", fg_color = "#caa153" },
    inactive_tab = { bg_color = "#0a0a0a", fg_color = "#8c6b2e" },
    inactive_tab_hover = { bg_color = "#8c6b2e", fg_color = "#d0d0d0" },
  },
}

local function window_frame(border_color, border_width)
  return {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
    border_left_width = border_width,
    border_right_width = border_width,
    border_top_height = border_width,
    border_bottom_height = border_width,
    border_left_color = border_color,
    border_right_color = border_color,
    border_top_color = border_color,
    border_bottom_color = border_color,
  }
end

config.window_frame = window_frame(ORANGE, FOCUSED_BORDER_WIDTH)

wezterm.on("window-focus-changed", function(window)
  local overrides = window:get_config_overrides() or {}
  if window:is_focused() then
    overrides.window_frame = nil
    overrides.colors = nil
    overrides.window_background_opacity = nil
  else
    overrides.window_frame = window_frame(UNFOCUSED_BORDER_COLOR, UNFOCUSED_BORDER_WIDTH)
    overrides.colors = UNFOCUSED_COLORS
    overrides.window_background_opacity = UNFOCUSED_OPACITY
  end
  window:set_config_overrides(overrides)
end)

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
config.show_close_tab_button_in_tabs = false

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

----------------------------------------------------
-- タブバー右側に git ブランチ / ホスト名 / 時刻を常時表示
-- https://github.com/ogadra/dotfiles/blob/main/home-manager/common/apps/terminal/wezterm/tab-bar.nix
----------------------------------------------------
config.tab_max_width = 200

-- ディレクトリごとの git ルートをキャッシュ(毎回 git を叩かないため)
local git_root_cache = {}

local function get_git_branch(cwd)
  if not cwd then
    return nil
  end
  local ok, stdout = wezterm.run_child_process({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
  if ok then
    return stdout:gsub("%s+$", "")
  end
  return nil
end

local function get_git_root(cwd)
  if not cwd then
    return nil
  end
  local ok, stdout = wezterm.run_child_process({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })
  if ok then
    return stdout:gsub("%s+$", "")
  end
  return nil
end

local function shorten_path(path)
  local home = os.getenv("HOME")
  if home and path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

local function extract_path(url_or_path)
  if not url_or_path then
    return nil
  end
  local path = url_or_path:match("^file://[^/]*(/.*)$")
  if path then
    return path:gsub("/+$", "")
  end
  if url_or_path:sub(1, 1) == "/" then
    return url_or_path:gsub("/+$", "")
  end
  return nil
end

local function update_git_root_cache(url_or_path)
  local path = extract_path(url_or_path)
  if not path then
    return
  end
  if git_root_cache[path] == nil then
    git_root_cache[path] = get_git_root(path) or false
  end
end

-- gitリポジトリ内なら "リポジトリ名/相対パス"、そうでなければ ~ 短縮パス
local function get_display_path(url_or_path)
  local path = extract_path(url_or_path)
  if not path then
    return ""
  end
  local git_root = git_root_cache[path]
  if git_root then
    local repo_name = git_root:match("[^/]+$") or git_root
    if path == git_root then
      return repo_name
    end
    return repo_name .. "/" .. path:sub(#git_root + 2)
  end
  return shorten_path(path)
end

wezterm.on("format-window-title", function()
  return "TERMINAL"
end)

wezterm.on("update-status", function(window)
  window:set_left_status(wezterm.format({
    { Foreground = { Color = BLACK } },
    { Background = { Color = ORANGE } },
    { Text = " TERMINAL " },
    { Foreground = { Color = ORANGE } },
    { Background = { Color = BLACK } },
  }))
end)

local function add_status_segment(parts, text, separator)
  table.insert(parts, { Foreground = { Color = BLACK } })
  table.insert(parts, { Background = { Color = ORANGE } })
  table.insert(parts, { Text = separator })
  table.insert(parts, { Foreground = { Color = ORANGE } })
  table.insert(parts, { Background = { Color = BLACK } })
  table.insert(parts, { Text = " " .. text .. " " .. separator })
end

-- 元々 keybinds.lua にあった「アクティブなキーテーブル名」の表示もここに統合
-- (update-right-status は複数登録すると呼び出し順で上書きし合うため、1箇所にまとめる)
wezterm.on("update-right-status", function(window, pane)
  local cwd = pane:get_current_working_dir()
  local cwd_path = cwd and (cwd.file_path or tostring(cwd)) or nil

  for _, tab in ipairs(window:mux_window():tabs()) do
    local tab_pane = tab:active_pane()
    local tab_cwd = tab_pane:get_current_working_dir()
    if tab_cwd then
      update_git_root_cache(tab_cwd.file_path or tostring(tab_cwd))
    end
  end

  local status_parts = {}

  local key_table = window:active_key_table()
  if key_table then
    add_status_segment(status_parts, "TABLE: " .. key_table, SOLID_LEFT_ARROW)
  end

  local git_branch = get_git_branch(cwd_path)
  if git_branch then
    add_status_segment(status_parts, git_branch, SOLID_LEFT_ARROW)
  end
  add_status_segment(status_parts, wezterm.hostname():gsub("%..*", ""), SOLID_LEFT_ARROW)
  add_status_segment(status_parts, wezterm.strftime("%H:%M:%S"), SOLID_LEFT_ARROW)

  table.insert(status_parts, { Foreground = { Color = BLACK } })
  table.insert(status_parts, { Background = { Color = ORANGE } })
  table.insert(status_parts, { Text = " " })

  window:set_right_status(wezterm.format(status_parts))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local ok, result = pcall(function()
    -- アクティブタブはバーと同じオレンジに溶け込ませ、文字だけ暗色で「抜く」
    local background = DEEP_BLACK
    local foreground = DIM_ORANGE
    if tab.is_active then
      background = ORANGE
      foreground = DEEP_BLACK
    elseif hover then
      background = DIM_ORANGE
      foreground = WHITE
    end
    local edge_background = ORANGE
    local edge_foreground = background

    local cwd = tab.active_pane.current_working_dir
    local dir_text
    if cwd then
      dir_text = get_display_path(cwd.file_path or tostring(cwd))
    end
    if not dir_text or dir_text == "" then
      dir_text = tab.active_pane.title
    end
    local title = "   " .. wezterm.truncate_right(dir_text, max_width - 1) .. "   "

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end)
  if ok then
    return result
  end
  -- 何かエラーが出てもタブが空白にならないようフォールバック
  return { { Text = "  " .. tab.active_pane.title .. "  " } }
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables
config.mouse_bindings = keybinds.mouse_bindings
-- tmux prefixをC-qに統一したため、WezTerm自体のLeaderは空いたC-aに移動(C-qのままだと衝突する)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

return config

