#!/bin/sh

busctl call --user org.freedesktop.systemd1 /org/freedesktop/systemd1 \
       org.freedesktop.systemd1.Manager StartTransientUnit 'ssa(sv)a(sa(sv))' \
       'abcdefg.scope' fail 1 PIDs au 1 $$ 0 &

exec kitty
