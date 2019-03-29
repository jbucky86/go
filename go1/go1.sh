sudo apt update #&& sudo apt upgrade -y
sudo apt-get install cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev git -y
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
cd build
cmake ../
make
make test
sudo make install
sudo ldconfig

cd ~/srsLTE
cp srsepc/epc.conf.example srsepc/epc.conf
cp srsepc/user_db.csv.example srsepc/user_db.csv

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

#Enbale IP Network do not use sudo
ifconfig
cd ~/srsLTE/srsepc
sudo su
./if_masq.sh [Interface for Internet connection]
EOF"
