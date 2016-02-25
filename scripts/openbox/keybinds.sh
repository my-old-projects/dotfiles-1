#!/bin/mksh
# Script to easily map commands to keys in openbox
#
# Created by Dylan Araps
# https://github.com/dylanaraps/dotfiles

volup () {
    # amixer set Master 5+
    pulseaudio-ctl up
    popup -e "$(amixer get Master | egrep -o '[0-9]+\%')" -w 150 -x 1670 &
}

voldown () {
    # amixer set Master 5-
    pulseaudio-ctl down
    popup -e "$(amixer get Master | egrep -o '[0-9]+\%')" -w 150 -x 1670 &
}

prevsong () {
    mpc prev
    current="$(mpc current)"
    width=$(txtw "$current")
    popup -e "$current" -w $width -x $((1820 - width)) &
}

nextsong () {
    mpc next

    current="$(mpc current)"
    width=$(txtw "$current")
    popup -e "$current" -w $width -x $((1820 - width)) &
}

togglesong () {
    mpc toggle

    current="$(mpc current)"
    width=$(txtw "$current")
    if [ "$(mpc | awk -F '\\[|\\]' '/\[/ {printf $2}' 2>/dev/null)" == "playing" ]; then
        popup -e "$current" -w $width -x $((1820 - width)) &
    else
        popup -e "Paused" -w 150 -x 1670 &
    fi
}

dmenu () {
    dmenu_run -s 0 -nb "#$white" -nf "#$black" -sb "#$white" -sf "#$gray" -i -h 60 -w 250 -q -x 30 -y 30 -fn "roboto-16" -p ">" -l 1
}

screenshot () {
    popup -e "Saved Screenshot" -s 4 -w 150 -x 1670 & sleep 1; \

    # What to name the image and where to save it
    img="scrot-$(date "+%d%b")-$RANDOM.png"
    dir="$HOME/Pictures/scrots"

    # Take the scrot
    scrot -q 100 "$img" -e "mv $img $dir"

    # Crop out the surrounding monitors
    convert -crop 1920x1080+0+0 "$dir/$img" "$dir/$img"
}

minify () {
    wrs -a 355 270 $(pfw)
}

case $1 in
    volup) volup ;;
    voldown) voldown ;;
    prevsong) prevsong ;;
    nextsong) nextsong ;;
    togglesong) togglesong ;;
    dmenu) dmenu ;;
    screenshot) screenshot ;;
    minify) minify ;;
esac

