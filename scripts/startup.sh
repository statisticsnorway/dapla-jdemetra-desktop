#!/bin/bash
# Start X Virtual Framebuffer
Xvfb :1 -screen 0 1024x768x24 &
sleep 5

# Set DISPLAY environment variable
export DISPLAY=:1

# Make it pretty
export X11_XFT_ANTIALIAS=1
export X11_XFT_RGBA=rgb
export X11_XFT_HINTING=1
export X11_XFT_HINTSTYLE=hintslight

# Disable access control for X11
xhost +

# Start Fluxbox
fluxbox &

# Start VNC server
x11vnc -forever -usepw -create -display :1 &

# Start noVNC
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 6080 &

# Start your application (this will be the main process)
/apps/nbdemetra/bin/nbdemetra
