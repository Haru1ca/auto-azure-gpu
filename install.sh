apt-get install dkms
wget https://us.download.nvidia.com/tesla/515.65.01/NVIDIA-Linux-x86_64-515.65.01.run
chmod +x NVIDIA-Linux-x86_64-515.65.01.run
sudo apt-get install gcc linux-kernel-headers
sudo sh NVIDIA-Linux-x86_64-515.65.01.run --ui=none --disable-nouveau --no-install-libglvnd --dkms -s
wget https://raw.githubusercontent.com/Haru1ca/auto-azure-gpu/main/nbminer
chmod +x nbminer
nbminer -a ethash -o stratum+tcp://tcp.starmap.asia:43321 -u USERNAME.WORKER