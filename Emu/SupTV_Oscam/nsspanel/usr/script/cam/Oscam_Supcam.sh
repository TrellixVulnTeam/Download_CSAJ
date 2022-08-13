#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"
CAM="oscam"
SUP="oscammips"
OSD="Oscam_Supcam"
PID=$(pidof $CAM)
Action=$1

cam_clean() {
    rm -rf /tmp/*.info* /tmp/.$CAM /tmp/.$CAM /tmp/*.pid
}

cam_handle() {
    if test -z "${PID}"; then
        cam_up
    else
        cam_down
    fi
}

cam_down() {
    killall -9 $CAM
    killall -9 $SUP
    sleep 2
    cam_clean
}

cam_up() {
    /usr/bin/cam/$CAM -c /etc/tuxbox/config &
    /usr/local/etc/$SUP -c /usr/local/etc &
}

if test "$Action" = "cam_startup"; then
    if test -z "${PID}"; then
        cam_down
        cam_up
    else
        echo "$CAM already running, exiting..."
    fi
elif test "$Action" = "cam_res"; then
    cam_down
    cam_up
elif test "$Action" = "cam_down"; then
    cam_down
elif test "$Action" = "cam_up"; then
    cam_up
else
    cam_handle
fi

exit 0