#!/bin/bash
#
[ -r /opt/vbox/vms ] && . /opt/vbox/vms

VBOXMANAGE=/usr/bin/VBoxManage

start()
{
	for v in $VMS; do
		$VBOXMANAGE startvm -type headless $v
	done
}

stop()
{
	VMS=`$VBOXMANAGE list runningvms | sed -e 's/^".*".*{\(.*\)}/\1/' 2>/dev/null`
	if [ -n "$VMS" ]; then
		for v in $VMS; do
        	$VBOXMANAGE controlvm $v savestate
        done
	fi
}

case "$1" in
	start)
	    start
	    ;;
	stop)
		stop
	    ;;
	restart)
	    stop && start
	    ;;
	*)
	    echo "Usage: $0 {start|stop|save|restart}"
	    exit 1
esac

exit 0

