# set up the ubuntu 16.04 LTS linux system.
# For simplicity, we partition 3 disks:
/ # one is for boot, if you have enough disk space, please allocate more than 100 GB for boot.

swap # one is for swap, basically, It is allocated twice size with your RAM, if you RAM is 32 GB, please allocate 64 GB for swap

/data # one is for data, all the left disk space are allocated to data disk. 

# After installtion of your ubuntu operation system, you may need to set up static IP address:
# First thing you need to do is to enable SSH in ubuntu 16.04.

sudo apt-get install openssh-server

sudo vim /etc/ssh/sshd_config // please run sudo nano /etc/ssh/sshd_config

change Permit RootLogin to yes

# then go to /etc/network/interfaces folder to set up the static IP address

sudo nano /etc/network/interfaces

# change to 

auto eth0

iface eth0 inet static

address 192.168.107.160

gateway 192.168.107.2 // you could get the infor from the properties of your network

netmask 255.255.255.0

dns-nameservers 8.8.8.8

# Then, change to/etc/NetworkManager/NetworkManager.conf folder

sudo nano /etc/NetworkManager/NetworkManager.conf

[if updown] managed = false  // change false to true
# Please setup four machines. One is for namenode, Other three are for datanode.
 
