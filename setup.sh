. $(dirname "$0")/functions.sh

STEP=001
if [ ! -f "${LOGDIR}/${STEP}" ]; then
    echo "does not exist"
    # step1 - Install
    start
    #-------------------------------------------------
    gpg -d keys.tar.gz.gpg | tar -xvzf -
    mkdir ~/.ssh
    cp home/glennpoder/keys/* ~/.ssh/
    #-------------------------------------------------
    finish
fi

STEP=002
if [ ! -f "${LOGDIR}/${STEP}" ]; then
    # step2 - Update and upgrade
    start
    #-------------------------------------------------
    export DEBIAN_FRONTEND=noninteractive
    export DEBIAN_PRIORITY=critical
    sudo -E apt-get -qy update
    sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
    sudo -E apt-get -qy autoclean
    #-------------------------------------------------
    finish
fi

STEP=003
if [ ! -f "${LOGDIR}/${STEP}" ]; then
    # step3 - Install docker
    start
    #-------------------------------------------------
    sudo apt-get install -y \
       ca-certificates \
       curl \
       gnupg \
       lsb-release \
       python3-pip

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      
   export DEBIAN_FRONTEND=noninteractive
   export DEBIAN_PRIORITY=critical
   sudo -E apt-get -qy update

   sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin

   group=docker
   if grep -q "^${group}:" /etc/group
    then
        sudo usermod -aG docker $USER
    else
        sudo groupadd docker
        sudo usermod -aG docker $USER
    fi
    
    #newgrp docker
    
    echo "***** reboot and restart this script *******"
    
    #-------------------------------------------------
    finish
    exit 0
fi

STEP=004
if [ ! -f "${LOGDIR}/${STEP}" ]; then
    # step4 - Setup docker containers part 1
    start
    #-------------------------------------------------
    rm -rf ~/.config/docker-dev
    rm -rf ~/docker-dev
    cd ~
    git clone git@git.catalyst-au.net:elearning/docker-dev.git
    
    mkdir ~/.config/docker-dev
    echo -en "[DEFAULT]\nDOCKER_DEV_ROOT=$HOME/docker-dev" > ~/.config/docker-dev/config
    cd docker-dev
    pip install --editable .docker/python
    
    echo '' >> ~/.bashrc
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    echo '' >> ~/.bashrc
    echo 'if [ -f ~/.config/docker-dev/config ]; then' >> ~/.bashrc
    echo '  eval $(grep "^DOCKER_DEV_ROOT=" ~/.config/docker-dev/config)' >> ~/.bashrc
    echo '  eval "$(_CONTROL_COMPLETE=bash_source control)"' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
    
    source ~/.bashrc
    
    echo "***** reboot and restart this script *******"
    
    #-------------------------------------------------
    finish
    exit 0
fi

STEP=005
if [ ! -f "${LOGDIR}/${STEP}" ]; then
    # step5 - Setup docker containers part 2
    start
    #-------------------------------------------------
    control build
    #-------------------------------------------------
    finish
fi

exit 0
