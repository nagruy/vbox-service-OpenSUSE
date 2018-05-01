# vbox-service-OpenSUSE
OpenSUSE systemctl service

* Place vbox.service in /etc/systemd/system/ directory (you'll need root access).
* Create directory /opt/vbox/ and place vbox.sh within.
* Grant executing permissions on vbox.sh<br>
sudo chmod +x /opt/vbox/vbox.sh
* Place vms file in your home directory edit it, and hide it.
mv vms $HOME/.vms
* Enable service by executing on terminal:<br>
sudo systemctl enable vbox.service
