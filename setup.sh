gpg -d keys.tar.gz.gpg | tar -xvzf -
mkdir ~/.ssh
cp home/glennpoder/keys/* ~/.ssh/

sudo apt-get update
sudo apt-get install \
   ca-certificates \
   curl \
   gnupg \
   lsb-release
# add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# set up the repo
echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# do the engine install
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin
# you could test by running hello-world but only if you plan to be running docker with sudo
   sudo docker run hello-world
# [OPTIONAL] set it up so you don't need all sudo all the time (note this isn't super secure so maybe be circumspect about trying this at home)
#  make a docker group and add yourself to it
  sudo groupadd docker
  sudo usermod -aG docker $USER
#  apply the change
  newgrp docker
