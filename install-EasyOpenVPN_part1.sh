#Changelog
#2010-12-4  > Added tls-auth to scripts.
#2010-11-12 > 10:27a EST > A few bug fixes and edits
#2010-11-11 > 3:16p EST > Initial Release
#2011-9-28 > Forced lzo-devel to download from Openvpn

#Make sure date is set
rdate -t 4 -s 129.6.15.28

echo "Downloading required files ........."
cd /root/EasyOpenVPN
wget http://openvpn.net/release/openvpn-2.1.0.tar.gz
wget http://openvpn.net/release/lzo-1.08-4.rf.src.rpm
wget http://www.opensc-project.org/files/pkcs11-helper/pkcs11-helper-1.07.tar.bz2 
wget ftp://ftp.muug.mb.ca/mirror/fedora/epel/5/x86_64/pkcs11-helper-devel-1.07-2.el5.1.i386.rpm
wget ftp://ftp.muug.mb.ca/mirror/fedora/epel/5/x86_64/pkcs11-helper-1.07-2.el5.1.i386.rpm

echo "Installing required files ........." 
yum install rpm-build -y
yum install autoconf -y
yum install automake -y
yum install imake -y
yum install autoconf.noarch -y
yum install zlib-devel -y
yum install pam-devel -y
yum install openssl-devel -y
#yum install lzo-devel -y
#
rpmbuild --rebuild /root/EasyOpenVPN/lzo-1.08-4.rf.src.rpm
rpm -Uvh /usr/src/redhat/RPMS/i386/lzo-*.rpm
rpm -Uvh /usr/src/redhat/RPMS/x86_64/lzo-*.rpm
rpm -ivh /root/EasyOpenVPN/pkcs11-helper-*.rpm
 
#Fix openvpn.spec file
cp /root/EasyOpenVPN/openvpn.spec.fixed /usr/src/redhat/SPECS/openvpn.spec

cp openvpn-2.1.0.tar.gz /usr/src/redhat/SOURCES/
rpmbuild -bb /usr/src/redhat/SPECS/openvpn.spec

#Install
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  # 64-bit stuff here
rpm -ivh /usr/src/redhat/RPMS/x86_64/lzo-*.rpm
rpm -ivh /usr/src/redhat/RPMS/x86_64/openvpn-2.1.0-1.x86_64.rpm
else
  # 32-bit stuff here
rpm -ivh /usr/src/redhat/RPMS/i386/lzo-*.rpm
rpm -ivh /usr/src/redhat/RPMS/i386/openvpn-2.1.0-1.i386.rpm
fi


echo "Copying sample files"
cp -r /usr/share/doc/openvpn-2*/easy-rsa/ /etc/openvpn/
cp /usr/share/doc/openvpn-2*/sample-config-files/server.conf /etc/openvpn/
clear
echo "##############################################"
echo "STOP AND EDIT  /etc/openvpn/easy-rsa/2.0/vars"
echo "EDIT THE EXPORT lines at end of file"

echo "export KEY_COUNTRY="
echo "export KEY_PROVINCE="
echo "export KEY_CITY="
echo "export KEY_ORG="
echo "export KEY_EMAIL="
chkconfig openvpn on
