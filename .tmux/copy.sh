#!/bin/sh
if command -v xsel >/dev/null 2>&1; then
    xsel -ib
elif command -v pbcopy >/dev/null 2>&1; then
    pbcopy
elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
else
    # fallback: just discard, or write to a file
    cat > /dev/null
fi
