#!/bin/bash
#
# ¿Existe el comando 'VBoxManage'? | # Does 'VBoxManage' command exists?
VBOX_MANAGE=/usr/bin/VBoxManage
if [[ ! -x $VBOX_MANAGE ]]; then
  echo "$VBOX_MANAGE no existe"
  exit 1;
fi

# Comando para encender las vms. | # Command for starting vms type headless.
VBOX_HEADLESS="$VBOX_MANAGE startvm -type headless"

# Usuarios que se encuentran en el grupo 'vboxusers' (agrego a root) | # Users in 'vboxusers' group (and root)
VBOX_USERS=`/usr/bin/getent group vboxusers | /usr/bin/cut -d : -f 4 | /usr/bin/sed "s/,/\n/g" | /usr/bin/sed "1 i\root"`;

start()
{
    # Para cada usuario del grupo 'vboxusers'. | # For each user in 'vboxusers'
    for user in $VBOX_USERS; do

        # Home del usuario. | # User home
        USER_HOME="`/usr/bin/getent passwd $user | /usr/bin/cut -d: -f 6`";

        # lista de vms | # vms list
        VMS_FILE="$USER_HOME/.vms";

        # ¿Existe el archivo de lista? | # vms list file exists?
        if [ -f $VMS_FILE ] ; then

            # 'Cargo' la variable VMS | # source file
            [ -r $VMS_FILE ] && . $VMS_FILE

            # La variable debe llamarse 'VMS' | # var must be called VMS
            for vm in $VMS; do

                # Enciendo la vm headless. | # starting vms headless mode.
                /usr/bin/su - $user -c "$VBOX_HEADLESS $vm"

            done                        
        fi
    done
}

stop()
{
    # Para cada usuario del grupo vboxusers. | # For each user in 'vboxusers'
    for user in $VBOX_USERS; do

        # Lista de vms encendidas. | # state on vms list
        VMS_ON=`/usr/bin/sudo /usr/bin/su - $user -c "$VBOX_MANAGE list runningvms" | /usr/bin/cut -d ' ' -f 1 | /usr/bin/sed 's/\"//g'`

        for vm in $VMS_ON; do
            # Guardo estado de las vms. | # Save vms state
            /usr/bin/su - $user -c "$VBOX_MANAGE controlvm $vm savestate"
        done
    done
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
