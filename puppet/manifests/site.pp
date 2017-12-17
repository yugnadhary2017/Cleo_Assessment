node 'ip-10-0-0-140.ec2.internal' {
	package { "http" :
		ensure => 'installed',
		}
	service { "httpd" :
		ensure => 'running',
		enable => 'ture',
		}
}
