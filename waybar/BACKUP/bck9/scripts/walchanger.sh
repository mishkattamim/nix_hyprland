#!/usr/bin/env bash

# Directory containing your wallpapers
WALLPAPER_DIR="/home/ryuuma/Pictures/Wallpapers"

# A file to store the index of the last set wallpaper
INDEX_FILE="$HOME/.cache/current_wallpaper"

# 1. Get a list of supported wallpaper files (e.g., jpg, jpeg, png)
# Adjust this list as needed for your file types
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

TOTAL_WALLPAPERS=${#WALLPAPERS[@]}

# Exit if no wallpapers found
if [ "$TOTAL_WALLPAPERS" -eq 0 ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# 2. Determine the next wallpaper index
if [ -f "$INDEX_FILE" ]; then
    CURRENT_INDEX=$(cat "$INDEX_FILE")
    NEXT_INDEX=$(( (CURRENT_INDEX + 1) % TOTAL_WALLPAPERS ))
else
    # Start with the first wallpaper if no index file exists
    NEXT_INDEX=0
fi

NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# 3. Apply the new wallpaper using swww
# Use 'steam-run' as requested
echo "Setting wallpaper: $NEXT_WALLPAPER"
steam-run swww img "$NEXT_WALLPAPER" --transition-type outer --transition-step 30

# 4. Generate color scheme with pywal
echo "Generating color scheme with pywal..."
steam-run wal -i "$NEXT_WALLPAPER" -n # -n prevents wal from setting the wallpaper again

# 5. Apply Pywal colors to Waybar and terminal
# For Waybar, you often need to reload its style.css or restart it.
# Check your Waybar configuration for the best way to reload the theme.
echo "Reloading Waybar..."
pkill waybar && waybar & # Simple restart (you might need to adjust this for your NixOS setup)

# For terminals, pywal generates a file with color sequences (e.g., ~/.cache/wal/sequences).
# Your terminal emulator (like Alacritty or Kitty) and shell startup files (like ~/.bashrc or ~/.zshrc)
# need to source this file. This step is typically handled in your NixOS config or shell profile.
# For example, in your shell profile: `(cat "$HOME/.cache/wal/sequences" &)`

# 6. Save the new index for the next run
echo "$NEXT_INDEX" > "$INDEX_FILE"

echo "Script finished. Next index is $NEXT_INDEX"
