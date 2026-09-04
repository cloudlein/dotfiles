local M = {
	terminal = "kitty",
	fileManager = "dolphin",
	menu = "rofi -show drun",
	screenshot = 'grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy',
	pathWallpaperPicker = "~/.config/hypr/scripts/wallpaper-picker.sh",
}

return M
