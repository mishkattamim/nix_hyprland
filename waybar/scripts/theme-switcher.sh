#!/usr/bin/env bash

# Directory containing your wallpapers
WALLPAPER_DIR="/home/ryuuma/Pictures/Wallpapers"

# 1. Get a list of supported wallpaper files (e.g., jpg, jpeg, png)
# Adjust this list as needed for your file types
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

TOTAL_WALLPAPERS=${#WALLPAPERS[@]}

# Exit if no wallpapers found
if [ "$TOTAL_WALLPAPERS" -eq 0 ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# 2. Select a RANDOM wallpaper 🎲
# $RANDOM generates a random integer. We use modulo to fit it within the array size.
RANDOM_INDEX=$(( $RANDOM % TOTAL_WALLPAPERS ))
NEXT_WALLPAPER="${WALLPAPERS[$RANDOM_INDEX]}"

# 3. Apply the new wallpaper using swww
# Use 'steam-run' as requested
echo "Setting wallpaper: $NEXT_WALLPAPER"
# The swww img command will set the wallpaper
steam-run swww img "$NEXT_WALLPAPER" --transition-type outer --transition-step 30

# 4. Generate color scheme with pywal
echo "Generating color scheme with pywal..."
# The -n flag prevents pywal from setting the wallpaper again (since swww already did it)
steam-run wal -i "$NEXT_WALLPAPER" -n

# 5. Apply Pywal colors to Waybar and terminal
# Reload Waybar to pick up the new colors from ~/.cache/wal/colors-waybar.css
echo "Reloading Waybar..."
# This is a common way to restart Waybar on Hyprland/Wayland
pkill waybar && nohup waybar & 

# Terminal colors are applied when a new terminal is opened, 
# provided your shell config sources the pywal sequences file.
echo "Terminal colors set via shell configuration (e.g. ~/.cache/wal/sequences)."

echo "Script finished. Wallpaper changed to: $NEXT_WALLPAPER"
