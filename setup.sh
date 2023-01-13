gpg -d keys.tar.gz.gpg | tar -xvzf -
mkdir ~/.ssh
cp home/glennpoder/keys/* ~/.ssh/

sudo apt-get update
sudo apt-get install \
   ca-certificates \
   curl \
   gnupg \
   lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
sudo -E apt-get -qy update
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
sudo -E apt-get -qy autoclean

  sudo groupadd docker
  sudo usermod -aG docker $USER

newgrp docker

cd ~
git clone git@git.catalyst-au.net:elearning/docker-dev.git

mkdir ~/.config/docker-dev
echo -en "[DEFAULT]\nDOCKER_DEV_ROOT=$HOME/docker-dev" > ~/.config/docker-dev/config
cd docker-dev
pip install --editable .docker/python
