#!/bin/bash

# Theme Switcher Script
WALLPAPER_DIR="$HOME/new-dotfiles/assets"
CURRENT_WALLPAPER_FILE="$HOME/.cache/current_wallpaper"

# Collect wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Theme Switcher" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Helpers
get_current_index() {
    [[ -f "$CURRENT_WALLPAPER_FILE" ]] && cat "$CURRENT_WALLPAPER_FILE" || echo "0"
}

apply_theme() {
    local wallpaper_path="$1"
    local index="$2"
    local wallpaper_name
    wallpaper_name=$(basename "$wallpaper_path")

    echo "$index" >"$CURRENT_WALLPAPER_FILE"

    # Always grow from top-left
    swww init &>/dev/null || true
    swww img "$wallpaper_path" \
        --transition-type grow \
        --transition-fps 60 \
        --transition-duration 1.2 \
        --transition-pos top-left

    # Generate and apply new color scheme with pywal
    wal -i "$wallpaper_path"

    # Restart Waybar to apply new colors
    pkill waybar
    waybar & disown

    update_hyprlock_wallpaper "$wallpaper_path"
    notify-send "Theme Switcher" "Applied: $wallpaper_name"
}

update_hyprlock_wallpaper() {
    local wallpaper_path="$1"
    local hyprlock_config="$HOME/.config/hypr/hyprland/hyprlock.conf"

    [[ ! -f "${hyprlock_config}.backup" ]] && cp "$hyprlock_config" "${hyprlock_config}.backup"

    sed -i "/background {/,/}/{s|path = .*|path = $wallpaper_path|}" "$hyprlock_config"
}

restore_theme() {
    local index
    index=$(get_current_index)
    apply_theme "${WALLPAPERS[$index]}" "$index"
}

# Main
case "${1:-next}" in
"next")
    next_index=$((($(get_current_index) + 1) % ${#WALLPAPERS[@]}))
    apply_theme "${WALLPAPERS[$next_index]}" "$next_index"
    ;;
"random")
    random_index=$((RANDOM % ${#WALLPAPERS[@]}))
    apply_theme "${WALLPAPERS[$random_index]}" "$random_index"
    ;;
"restore")
    restore_theme
    ;;
"list")
    # Show only filenames in wofi
    selected=$(printf "%s\n" "${WALLPAPERS[@]##*/}" | wofi --dmenu --prompt "Choose Wallpaper" --insensitive)

    if [ -n "$selected" ]; then
        for i in "${!WALLPAPERS[@]}"; do
            if [[ "${WALLPAPERS[$i]##*/}" == "$selected" ]]; then
                apply_theme "${WALLPAPERS[$i]}" "$i"
                break
            fi
        done
    else
        notify-send "Theme Switcher" "No wallpaper selected."
    fi
    ;;
esac
