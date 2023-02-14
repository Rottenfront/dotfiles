#!/bin/sh

userresources=~/.Xresources
usermodmap=~/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

setxkbmap -model pc86 -layout us,ru, -option grp:win_space_toggle

# tapping
xinput set-prop "ETPS/2 Elantech Touchpad" "libinput Tapping Enabled" 1

# exec awesome

exec i3

# export DESKTOP_SESSION=plasma
# exec startplasma-x11
