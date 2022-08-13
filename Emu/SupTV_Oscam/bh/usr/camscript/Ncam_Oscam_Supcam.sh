#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

CAMNAME="Oscam_Supcam"

remove_tmp() {
    rm -rf /tmp/*.info* /tmp/*.tmp* /tmp/.oscam /tmp/*share* /tmp/*.pid* /tmp/*sbox* /tmp/oscam.* /tmp/*.oscam
}

case "$1" in
start)
    echo "[SCRIPT] $1: $CAMNAME"
    remove_tmp
    touch /tmp/.emu.info
    echo oscam >/tmp/.emu.info
    /usr/bin/oscam --config-dir /etc/tuxbox/config --daemon --pidfile /tmp/oscam.pid --restart 2 --utf8 &
    /usr/local/etc/oscammips --config-dir /usr/local/etc --daemon --pidfile /tmp/oscammips.pid --restart 2 --utf8 &
    ;;
stop)
    echo "[SCRIPT] $1: $CAMNAME"
    killall -9 oscam 2>/dev/null
    killall -9 oscammips 2>/dev/null
    remove_tmp
    ;;
restart)
    $0 stop
    sleep 2
    $0 start
    exit
    ;;
*)
    $0 stop
    exit 0
    ;;
esac

exit 0