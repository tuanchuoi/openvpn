#!/bin/bash

ersa="/config/easy-rsa"
buildkey="$ersa/build-key"

if [ ! -x /usr/bin/zip ];then
echo -e "\n zip not found.. To install zip add the following to /etc/apt/sources.list \n
deb http://archive.debian.org/debian squeeze main
deb http://archive.debian.org/debian squeeze-lts main \n
also add \"Acquire::Check-Valid-Until false;\" to /etc/apt/apt.conf \n
sudo apt-get update && apt-get install zip unzip \n
if on vyatta, uncomment the lines in sources.list when done \n"
exit
fi

if [ -z $1 ]; then
echo -e "Usage: $0 [username] [servername]"
echo -e "  or: $0 [username] [servername] pass \n"
echo -e "If you want the user to be prompted with a passphrase add \"pass\" to the end of the command."
echo -e "This will invoke \"build-key-pass\""
echo -e "[servername] needs to resolve to the openvpn server."
echo -e "   Example: $0 jason vpn.jasonschaefer.com pass\n"

exit
fi

if [ "$3" = "pass" ]; then
buildkey="$ersa/build-key-pass"
fi

echo -e "\nCreate openvpn client files and config for $1 \nPress enter to continue"
read

if [ -z $KEY_COUNTRY ]
then
source $ersa/vars
fi

echo "Creating key for $1"
$buildkey $1

echo "Creating $1 user configs"
/bin/mkdir $ersa/keys/$1
/bin/cp $ersa/keys/$1.key $ersa/keys/$1
/bin/cp $ersa/keys/$1.crt $ersa/keys/$1
/bin/cp $ersa/keys/ca.crt $ersa/keys/$1

echo "client
proto udp
remote-cert-tls server
dev tun
cert $1.crt
key $1.key
ca ca.crt
remote IPVPNServer VPNServerPort" > $ersa/keys/$1/$1.ovpn

cd $ersa/keys/ && /usr/bin/zip -r $1_ovpn.zip $1/
echo -n "Nhập email cần gửi, sau đó nhấn Enter:"
read mail
echo "Nội dung mail" | mutt $mail -a "/config/easy-rsa/keys/$1_ovpn.zip" -s "Tên tiêu đề"
echo -e "\n Done"
