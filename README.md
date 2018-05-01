# vbox-service-OpenSUSE
OpenSUSE systemctl service

* Place vbox.service in /etc/systemd/system/ directory (you'll need root access).
* Create directory /opt/vbox/ and place vbox.sh within.
* Grant executing permissions on vbox.sh<br>
sudo chmod +x /opt/vbox/vbox.sh
* Place vms file in /opt/vbox/ directory.
* Edit /opt/vbox/vms by adding your virtual machines names (the ones you want to start at boot time).
* Enable service by executing on terminal:<br>
sudo systemctl enable vbox.service
