# Cleo_Assessment

To login EC2 instances use .pem key 
yugandhar_automation.pem

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


