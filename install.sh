#!/bin/bash
######Install web server #################
rpm -qa |grep httpd
x=`echo $?`
if [ $x -eq 0 ]
then
     echo "apache server installed"
else
     echo "apache server in not installed"
     echo "Now installing apache server........!"
     yum install httpd php php* -y 
     systemctl start http && systemctl enable httpd
fi

#######Installing Docker Engine on EC2 #############
rpm -qa | grep docker
y=`echo $?`
if [ $y -qa 0 ]
then
    echo "docker is already installed"
else
    echo "Docker is not installed..."
        echo "Docker is going to be instlled..........!"
        echo "..................................................."
        echo "Installing Docker prerequisites....! "
        yum install yum-utils device-mapper-persistent-data lvm2 -y
        echo ".................................................."
    echo "Configuring Docker CE repo.......................!"
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        echo "..............................................."
    echo "Installing Docker CE ....................!"
        yum install ftp://ftp.icm.edu.pl/vol/rzm6/linux-centos-vault/7.3.1611/extras/x86_64/Packages/container-selinux-2.9-4.el7.noarch.rpm -y
        yum install docker-ce -y
        systemctl start docker 
        systemctl enable docker
fi

