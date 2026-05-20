#!/bin/sh

: "${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}"
: "${WAYLAND_DISPLAY:?WAYLAND_DISPLAY is not set}"

socket="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"

lines=$(ss -xlp --no-header "src $socket")

pid=${lines#*pid=}
pid=${pid%%,*}

: "${pid:?Failed to get compositor PID}"
echo "$pid"
