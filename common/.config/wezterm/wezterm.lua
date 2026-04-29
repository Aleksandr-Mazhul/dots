local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.enable_kitty_keyboard = true
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 30
config.colors = require("modules.colors")
config.keys = require("modules.keys")(act)

local home = wezterm.home_dir or os.getenv("HOME")
local target = wezterm.target_triple or ""
if target:find("darwin", 1, true) then
  local ok, override = pcall(dofile, home .. "/.config/wezterm/macos.lua")
  if ok and type(override) == "function" then
    override(config, wezterm)
  end
elseif target:find("linux", 1, true) then
  local ok, override = pcall(dofile, home .. "/.config/wezterm/linux.lua")
  if ok and type(override) == "function" then
    override(config, wezterm)
  end
end

return config
