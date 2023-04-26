#!/bin/bash

# Verifica se o VirtualBox está instalado
if ! dpkg -s "virtualbox-7.0" &> /dev/null; then
    echo "VirtualBox não está instalado. Instalando o VirtualBox..."
    # Instala o VirtualBox usando o apt-get
    sudo apt-get update
    sudo apt-get install -y virtualbox
fi

# Verifica se o Vagrant está instalado
if ! dpkg -s vagrant &> /dev/null; then
    echo "Vagrant não está instalado. Instalando o Vagrant..."
    # Instala o Vagrant usando o apt-get
    sudo apt-get update
    sudo apt-get install -y vagrant
fi

# Verifica se o usuário atual é membro do grupo vboxusers
if ! id -nG | grep -qw vboxusers; then
    echo "O usuário atual não é membro do grupo vboxusers. Adicionando o usuário ao grupo..."
    # Adiciona o usuário atual ao grupo vboxusers
    sudo usermod -aG vboxusers $USER
fi

cd vagrant/

vagrant up 

export VAR=$(vagrant ssh-config | grep "IdentityFile" | awk 'NR==1{ print $2 }')
sed -i "s|CHANGE|$VAR|g" ../inventory.ini
cd ..
ansible-playbook -i inventory.ini playbook.yml
