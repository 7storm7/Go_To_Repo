#!/usr/bin/env bash
# Prerequisites:
#  1. xclip
#  2. wget
#  3. notify-send

text="$(xclip -o)" # or xsel instead of xclip
translate="$(wget -U "Mozilla/5.0" -qO - "http://translate.googleapis.com/translate_a/single?client=gtx&sl=sv&tl=en&dt=t&q=$(echo $text | sed "s/[\"'<>]//g")" | sed "s/,,,0]],,.*//g" | awk -F'"' '{print $2, $6}')"
echo "$translate" | xclip -selection clipboard
notify-send -t 100000000  --icon=info "$text" "$translate"

echo $translate
