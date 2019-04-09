sudo apt update #&& sudo apt upgrade -y
sudo apt-get install cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev git curl net-tools -y
sudo apt-get install libboost-system-dev libboost-test-dev libboost-thread-dev libqwt-dev libqt4-dev -y
sudo apt-get install cmake g++ libpython-dev python-numpy swig libsqlite3-dev libi2c-dev libusb-1.0-0-dev libwxgtk3.0-dev freeglut3-dev -y

cd
#Lime SDR
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
mkdir build
cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

cd
git clone https://github.com/myriadrf/LimeSuite.git
cd LimeSuite
mkdir build
cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
cd ../udev-rules/
sudo chmod +x install.sh
sudo ./install.sh
# Download board firmware
sudo LimeUtil --update
###TEST lime###SoapySDRUtil --info
###TEST lime###SoapySDRUtil --probe

#cd
##srsGUI
#git clone https://github.com/srsLTE/srsGUI.git
#cd srsGUI
#mkdir build
#cd build
#cmake ../
#make
#sudo make install
#sudo ldconfig

cd
#srsLTE
git clone https://github.com/srsLTE/srsLTE.git
cd srsLTE
mkdir build
cd build
cmake ../
make
make test
sudo make install
sudo ldconfig

sudo add-apt-repository ppa:acetcom/nextepc
sudo apt-get update
sudo apt-get -y install nextepc
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sL http://nextepc.org/static/webui/install | sudo -E bash -

cd ~/srsLTE
#cp srsepc/epc.conf.example srsepc/epc.conf
#cp srsepc/user_db.csv.example srsepc/user_db.csv

cp srsenb/enb.conf.example srsenb/enb.conf
cp srsenb/rr.conf.example srsenb/rr.conf
cp srsenb/sib.conf.example srsenb/sib.conf
cp srsenb/drb.conf.example srsenb/drb.conf

cd
sudo /bin/sh -c "cat <<EOF > ~/Desktop/start_srsLTE.txt
#Terminal 1
cd ~/srsLTE/srsepc
sudo srsepc epc.conf

#Terminal 2
cd ~/srsLTE/srsenb
sudo srsenb enb.conf


diff -u mme.conf.old mme.conf
--- mme.conf.old    2018-04-15 18:28:31.000000000 +0900
+++ mme.conf    2018-04-15 19:53:10.000000000 +0900
@@ -14,18 +14,20 @@
 mme:
     freeDiameter: mme.conf
     s1ap:
+      addr: 127.0.1.100
     gtpc:
+      addr: 127.0.1.100
     gummei:
       plmn_id:
-        mcc: 001
-        mnc: 01
+        mcc: 901
+        mnc: 70
       mme_gid: 2
       mme_code: 1
     tai:
       plmn_id:
-        mcc: 001
-        mnc: 01
-      tac: 12345
+        mcc: 901
+        mnc: 70
+      tac: 7
     security:
         integrity_order : [ EIA1, EIA2, EIA0 ]
         ciphering_order : [ EEA0, EEA1, EEA2 ]

diff -u /etc/nextepc/sgw.conf.old /etc/nextepc/sgw.conf
--- sgw.conf.old    2018-04-15 18:30:25.000000000 +0900
+++ sgw.conf    2018-04-15 18:30:30.000000000 +0900
@@ -14,3 +14,4 @@
     gtpc:
       addr: 127.0.0.2
     gtpu:
+      addr: 127.0.0.2

diff enb.conf.example enb.conf
25,26c25,26
< mcc = 001
< mnc = 01
---
> mcc = 901
> mnc = 70
67c67,68
< dl_earfcn = 3400
---
> #dl_earfcn = 3400
> dl_earfcn = 1600
74a76
> device_args="clock=external"

#restart nextepc
sudo systemctl restart nextepc-mmed
sudo systemctl restart nextepc-sgwd

#if no internet on device
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o <'interface-name'> -j MASQUERADE
sudo iptables -I INPUT -i pgwtun -j ACCEPT

#start srs
cd ~/srsLTE
cd srsenb/
sudo ../build/srsenb/src/srsenb ./enb.conf

#Enbale IP Network do not use sudo
ifconfig
cd ~/srsLTE/srsepc
sudo su
./if_masq.sh [Interface for Internet connection]
EOF"
