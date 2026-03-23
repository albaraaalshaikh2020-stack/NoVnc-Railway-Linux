#!/bin/bash

# Kill any leftover processes
pkill Xvfb 2>/dev/null
pkill x11vnc 2>/dev/null
pkill startxfce4 2>/dev/null
pkill autocutsel 2>/dev/null
sleep 1

# Start virtual display
Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &
sleep 2

# Set environment for all processes
export DISPLAY=:1
export HOME=/root
export USER=root

# Start XFCE desktop
startxfce4 &
sleep 4

# Fix keyboard repeat rate
xset r rate 200 30 2>/dev/null || true

# Fix clipboard sync in both directions (browser -> desktop and desktop -> browser)
autocutsel -fork
autocutsel -selection PRIMARY -fork

# Start x11vnc - no password, full keyboard and clipboard support
x11vnc \
    -display :1 \
    -nopw \
    -forever \
    -shared \
    -rfbport 5900 \
    -noxdamage \
    -wait 5 \
    -xkb \
    -sel \
    -primary \
    -clipboard &
sleep 1

# Start noVNC - keeps container alive with exec
exec websockify \
    --web=/usr/share/novnc/ \
    0.0.0.0:${PORT:-8080} \
    localhost:5900
