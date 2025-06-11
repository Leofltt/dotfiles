#!/bin/bash

# Make sure 'jq' is installed (brew install jq)
# This script is designed for AeroSpace versions WITHOUT the 'tree' command and WITHOUT '--raw' flag (e.g., 0.18.5-Beta).
# It primarily checks if the focused window is floating. If not, it assumes tiled.
# It CANNOT accurately distinguish between horizontal/vertical tiling or accordion layouts for the workspace.

get_layout_indicator() {
    local layout_symbol=""

    # Get information about the focused window.
    # In 0.18.5-Beta, this returns something like "WindowId(12345) AppName [Workspace(1)]"
    local focused_window_info
    focused_window_info=$(aerospace list-windows --focused)

    if [ -n "$focused_window_info" ]; then
        # Extract the numerical Window ID from the string, e.g., from "WindowId(12345)" get "12345"
        # We use awk to split the string by '(' and ')' and take the second part.
        local focused_window_id
        focused_window_id=$(echo "$focused_window_info" | head -n 1 | awk -F'[()]' '{print $2}')

        if [ -n "$focused_window_id" ]; then
            # Query if the focused window is floating using its ID
            # The '--json' flag for list-windows --window-id should work in 0.18.5-Beta
            local is_focused_window_floating
            is_focused_window_floating=$(aerospace list-windows --window-id "$focused_window_id" --json | jq -r '.[0]."is-floating"')

            if [ "$is_focused_window_floating" = "true" ]; then
                layout_symbol="F" # Floating
            else
                layout_symbol="T" # Generic Tiled
            fi
        else
            # Fallback if parsing failed for some reason (e.g., unexpected output format)
            layout_symbol="T?" # Tiled or unknown, if ID extraction failed
        fi
    else
        # If no window is focused on the current workspace, or workspace is empty
        layout_symbol="T" # Default to Tiled, or '?' if you prefer
    fi

    echo "$layout_symbol"
}

# Execute the function to get the layout indicator
get_layout_indicator
