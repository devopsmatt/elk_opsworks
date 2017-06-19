#!/bin/bash
wget https://packages.chef.io/files/stable/chefdk/1.3.43/el/7/chefdk-1.3.43-1.el7.x86_64.rpm  
rpm -ivh chefdk-1.3.43-1.el7.x86_64.rpm 
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
echo 'eval "$(chef shell-init zsh)"' >> ~/.zshrc
