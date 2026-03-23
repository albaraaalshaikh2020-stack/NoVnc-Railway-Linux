#!/bin/bash

# Kill any existing processes
pkill Xvfb 2>/dev/null
pkill x11vnc 2>/dev/null

# Start Xvfb virtual display
Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &
sleep 2

# Start XFCE desktop
DISPLAY=:1 HOME=/root startxfce4 &
sleep 2

# Start x11vnc with NO password
x11vnc -display :1 -nopw -forever -shared \
    -rfbport 5900 -noxdamage -wait 5 -loop &
sleep 1

# Start noVNC websockify
websockify --web=/usr/share/novnc/ \
    0.0.0.0:${PORT:-8080} localhost:5900

wait
