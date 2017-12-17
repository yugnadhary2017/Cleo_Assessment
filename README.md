# Cleo_Assessment

To login EC2 instances use .pem key 
yugandhar_automation.pem

We are following "VPC with single public subnet" scenario for launching EC2 instance through puppet. You can look at the image "https://github.com/yugnadhary2017/Cleo_Assessment/commit/38b833673a1685fffe612c6b93ec987c94263198"




#####Puppetmaster Access_Details##############
We have launched one EC2 instance in AWS and configured it as puppet master to deploy and manage infrastructure.

Puppet master : Public DNS (IPv4) : ec2-54-242-47-24.compute-1.amazonaws.com
IPv4 Public IP : 54.242.47.24

puppet module location for luanching EC2 instnace : puppet/modules/cleo_assessmen/create.pp

=> VPC Creation : 

ec2_vpc { 'cleo-vpc':
  ensure     => present,
  region     => 'us-east-1',
  cidr_block => '10.0.0.0/24',
  tags       => [{
    name => 'cleo-vpc',
  }],
}

=> Internet_Gateway Creation :

ec2_vpc_internet_gateway { 'cleo-vpc-igw':
 ensure => present,
 region => 'us-east-1',
 vpc => 'cleo-vpc',
 }

=> Routing Table Creation :

ec2_vpc_routetable { 'cleo-vpc-route':
  ensure => 'present',
  region => 'us-east-1',
  routes => [
    {
        destination_cidr_block => '10.0.0.0/24',
        gateway => 'local'
}, {
       destination_cidr_block => '0.0.0.0/0',
       gateway => 'cleo-vpc-igw'
},
],
  tags   => {'name' => 'cleo-vpc-route'},
  vpc    => 'cleo-vpc',
}

=> VPC Subnet : 

ec2_vpc_subnet { 'cleo-subnet':
  ensure                  => present,
  region                  => 'us-east-1',
  cidr_block              => '10.0.0.0/24',
  availability_zone       => 'us-east-1d',
  map_public_ip_on_launch => true,
  vpc                     => 'cleo-vpc',
  tags                    => [{
  name              =>  'cleo-subnet',
  }],
}



=> VPC Security Group:

ec2_securitygroup { 'cleo-security-group':
  ensure      => present,
  region      => 'us-east-1',
  vpc         => 'cleo-vpc',
  description => 'cleo securitygroup',
  ingress     => [{
    protocol  => 'tcp',
    port      => 22,
    cidr      => '0.0.0.0/0',
  }],
  tags        => {
    name  => 'cleo-security-group',
  },
}


=> EC2 Instance : 

ec2_instance { 'cleo-instance':
  ensure            => running,
  region            => 'us-east-1',
  availability_zone => 'us-east-1d',
  image_id          => 'ami-c998b6b2', # you need to select your own AMI
  instance_type     => 't2.micro',
  key_name          => 'yugandhar_automation',
  subnet            => 'cleo-subnet',
  security_groups   => ['cleo-security-group'],
  tags              => {
    name => 'cleo-instance',
  },
}



############

=> We can manage the aws infra through puppet commands....
#puppet resource ec2_instance
#puppet resource ec2_vpc
#puppet resource ec2_vpc_internet_gateway 
#puppet resource ec2_vpc_routetable
#puppet resource ec2_vpc_subnet
#puppet resource ec2_securitygroup
#puppet resource ec2_instance 

Above commands are used for to get the information about AWS resources.

How do you apply puppet changes ?

#puppet parser validate /etc/puppet/modules/cleo_assessment/create.pp   # To validate the module

#puppet apply /etc/puppet/modules/cleo_assessment/create.pp    # apply puppet changes to launch aws instances


How do you access AWS EC2 Instances ?

ssh -i  yugandhar_automation.pem  ec2-user@54.235.231.143 -p 22 -v     # EC2 cleo_instance access 

ssh -i yugandhar_automation.pem ec2-user@54.242.47.24 -p 22 -v # EC2 puppetmaster access 


###############
####Installing APACHE and Docker Engine##########
Please have a look at the install.sh script for it.

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


###################################################

