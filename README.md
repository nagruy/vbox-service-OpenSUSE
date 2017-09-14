# vbox-service-OpenSUSE
OpenSUSE systemctl service

* Place vbox.service in /etc/systemd/system/ directory (you'll need root access).
* Create directory /opt/vbox/ and place vboxes.sh within.
* Place vms file in /opt/vbox/ directory.
* Edit /opt/vbox/vms by adding your virtual machines names (the ones you want to auto start ato boot time).
* Enable service by executing on terminal:<br>
sudo systemctl enable vbox.service
