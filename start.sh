#!/bin/bash

export DISPLAY=:1
export HOME=/root
export USER=root

# Start virtual display immediately
Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &

# Start XFCE in background
startxfce4 &

# Start x11vnc in background - no password
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

# Start clipboard sync
autocutsel -fork 2>/dev/null || true
autocutsel -selection PRIMARY -fork 2>/dev/null || true

# Start websockify IMMEDIATELY so Railway health check passes
exec websockify \
    --web=/usr/share/novnc/ \
    0.0.0.0:${PORT:-8080} \
    localhost:5900
