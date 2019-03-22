sudo /bin/sh -c "cat <<EOF > /etc/apt/sources.list
deb http://old-releases.ubuntu.com/ubuntu/ zesty main restricted
deb http://old-releases.ubuntu.com/ubuntu/ zesty-updates main restricted
deb http://old-releases.ubuntu.com/ubuntu/ zesty universe
deb http://old-releases.ubuntu.com/ubuntu/ zesty-updates universe
deb http://old-releases.ubuntu.com/ubuntu/ zesty multiverse
deb http://old-releases.ubuntu.com/ubuntu/ zesty-updates multiverse
deb http://old-releases.ubuntu.com/ubuntu/ zesty-backports main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu zesty-security main restricted
deb http://old-releases.ubuntu.com/ubuntu zesty-security universe
deb http://old-releases.ubuntu.com/ubuntu zesty-security multiverse
EOF"

sudo apt update #&& sudo apt upgrade -y
sudo apt-get install cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev git -y
sudo apt-get install libboost-system-dev libboost-test-dev libboost-thread-dev libqwt-dev libqt4-dev -y
sudo apt-get install cmake g++ libpython-dev python-numpy swig -y

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
###TEST lime###SoapySDRUtil --info
###TEST lime###SoapySDRUtil --probe

cd
#srsGUI
git clone https://github.com/srsLTE/srsGUI.git
cd srsGUI
mkdir build
cd build
cmake ../
make
sudo make install
Sudo ldconfig

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
sudo srslte_install_configs.sh service

cd
sudo /bin/sh -c "cat <<EOF > ~/Desktop/start_srsLTE.txt
#Terminal 1
sudo srsepc
#Terminal 2
sudo srsenb
EOF"
