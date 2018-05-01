#!/bin/bash
#
# Comando 'VBoxManage' ¿existe?
VBOX_MANAGE=/usr/bin/VBoxManage
if [[ ! -x $VBOX_MANAGE ]]; then
  echo "$VBOX_MANAGE no existe"
  exit 1;
fi

# Comando para encender las vms.
VBOX_HEADLESS="$VBOX_MANAGE startvm -type headless"

# Usuarios que se encuentran en el grupo 'vboxusers' (agrego a root)
VBOX_USERS=`/usr/bin/getent group vboxusers | /usr/bin/cut -d : -f 4 | /usr/bin/sed "s/,/\n/g" | /usr/bin/sed "1 i\root"`;

start()
{
    # Para cada usuario del grupo vboxusers.
    for user in $VBOX_USERS; do

        # Home del usuario.
        USER_HOME="`/usr/bin/getent passwd $user | /usr/bin/cut -d: -f 6`";

        # lista de vms
        VMS_FILE="$USER_HOME/.vms";

        # ¿Existe el archivo de lista?   
        if [ -f $VMS_FILE ] ; then

            # 'Cargo' la variable VMS
            [ -r $VMS_FILE ] && . $VMS_FILE

            # La variable debe llamarse 'VMS'
            for vm in $VMS; do

                # Enciendo la vm headless.
                /usr/bin/su - $user -c "$VBOX_HEADLESS $vm"

            done                        
        fi
    done
}

stop()
{
    # Para cada usuario del grupo vboxusers.
    for user in $VBOX_USERS; do

        # Lista de vms encendidas.
        VMS_ON=`/usr/bin/sudo /usr/bin/su - $user -c "$VBOX_MANAGE list runningvms" | /usr/bin/cut -d ' ' -f 1 | /usr/bin/sed 's/\"//g'`

        for vm in $VMS_ON; do
            # Guardo estado de las vms.
            echo "/usr/bin/su - $user -c \"$VBOX_MANAGE controlvm $vm savestate\""
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
