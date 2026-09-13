#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"
CURRENT_WALLPAPER="$HOME/.cache/current-wallpaper"
ROFI_THEME="$HOME/.config/rofi/wallpaper.rasi"
COLOR_THEME="$HOME/.config/rofi/color-picker.rasi"
SDDM_SYNC="$HOME/.config/sddm/themes/matugen/scripts/sync-wallpaper.sh"

mkdir -p "$(dirname "$CURRENT_WALLPAPER")"

for cmd in rofi matugen awww magick; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        notify-send "Wallpaper Picker" "Command tidak ditemukan: $cmd"
        exit 1
    fi
done

mapfile -t WALLPAPERS < <(
    find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" \
        -o -iname "*.jpeg" \
        -o -iname "*.png" \
        -o -iname "*.webp" \) |
        sort
)

if [ "${#WALLPAPERS[@]}" -eq 0 ]; then
    notify-send "Wallpaper Picker" "Tidak ada wallpaper di $WALLPAPER_DIR"
    exit 1
fi

SELECTED=$(
    for wallpaper in "${WALLPAPERS[@]}"; do
        printf '%s\0icon\x1f%s\n' \
            "$(basename "$wallpaper")" \
            "$wallpaper"
    done |
        rofi \
            -dmenu \
            -i \
            -show-icons \
            -p "Wallpaper" \
            -theme "$ROFI_THEME"
)

if [ -z "$SELECTED" ]; then
    exit 0
fi

WALLPAPER=""

for wallpaper in "${WALLPAPERS[@]}"; do
    if [ "$(basename "$wallpaper")" = "$SELECTED" ]; then
        WALLPAPER="$wallpaper"
        break
    fi
done

if [ -z "$WALLPAPER" ]; then
    notify-send "Wallpaper Picker" "Wallpaper tidak ditemukan"
    exit 1
fi

mapfile -t COLORS < <(
    magick "$WALLPAPER" \
        -resize "128x128^" \
        -gravity center \
        -extent 128x128 \
        -colors 5 \
        -unique-colors \
        txt:- 2>/dev/null |
    grep -oE '#[0-9A-Fa-f]{6}' |
    awk '!seen[$0]++' |
    head -n 5
)

if [ "${#COLORS[@]}" -eq 0 ]; then
    notify-send "Wallpaper Picker" "Gagal mengambil warna dari wallpaper"
    exit 1
fi

while [ "${#COLORS[@]}" -lt 5 ]; do
    COLORS+=("${COLORS[-1]}")
done

COLOR_SELECTED=$(
    for color in "${COLORS[@]}"; do
        printf '<span foreground="%s">■</span>  %s\n' \
            "$color" \
            "$color"
    done |
        rofi \
            -dmenu \
            -i \
            -markup-rows \
            -p "Source Color" \
            -theme "$COLOR_THEME"
)

if [ -z "$COLOR_SELECTED" ]; then
    exit 0
fi

SOURCE_COLOR=$(printf '%s\n' "$COLOR_SELECTED" |
    grep -oE '#[0-9A-Fa-f]{6}' |
    head -n 1)

if [ -z "$SOURCE_COLOR" ]; then
    notify-send "Wallpaper Picker" "Source color tidak valid"
    exit 1
fi

echo "$WALLPAPER" > "$CURRENT_WALLPAPER"

awww img "$WALLPAPER" \
    --transition-type any \
    --transition-duration 2.5

matugen color hex "$SOURCE_COLOR"

if pgrep -x waybar >/dev/null 2>&1; then
    pkill -SIGUSR2 waybar 2>/dev/null
fi

if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1
fi

if command -v kitty >/dev/null 2>&1; then
    kitty @ set-colors \
        --all \
        "$HOME/.config/kitty/matugen.conf" \
        >/dev/null 2>&1
fi

if pgrep -x nvim >/dev/null 2>&1; then
    pkill -SIGUSR1 nvim 2>/dev/null
fi

if [ -x "$SDDM_SYNC" ]; then
    "$SDDM_SYNC" "$WALLPAPER"
fi

notify-send \
    -i "$WALLPAPER" \
    "Wallpaper Changed" \
    "$(basename "$WALLPAPER")\n$SOURCE_COLOR"