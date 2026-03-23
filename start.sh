#!/bin/bash

# Kill any existing processes
pkill Xvfb 2>/dev/null
pkill x11vnc 2>/dev/null
pkill xfce4 2>/dev/null

# Update VNC password if VNC_PASS is set
if [ -n "$VNC_PASS" ]; then
    mkdir -p /root/.vnc
    echo "$VNC_PASS" | x11vnc -storepasswd - /root/.vnc/passwd
fi

# Start Xvfb virtual display
Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &
sleep 2

# Start XFCE desktop
DISPLAY=:1 HOME=/root startxfce4 &
sleep 2

# Start x11vnc server
x11vnc -display :1 -rfbauth /root/.vnc/passwd -forever -shared \
    -rfbport 5900 -noxdamage -wait 5 -loop &
sleep 1

# Start noVNC websockify
websockify --web=/usr/share/novnc/ \
    --cert=/etc/ssl/novnc.cert \
    --key=/etc/ssl/novnc.key \
    0.0.0.0:${PORT:-8080} localhost:5900

# Keep alive
wait
