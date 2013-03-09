default[:aegir][:frontend] = node['fqdn']
default[:aegir][:fqdn] = node['fqdn']
default[:aegir][:client_email] = "jon@thinkdrop.net"

default[:aegir][:version] = "6.x-1.x"
default[:aegir][:authorized_keys] = ""
default[:aegir][:dir] = "/var/aegir"
default[:aegir][:db_host] = "localhost"
default[:aegir][:profile] = "hostmaster"
default[:aegir][:makefile] = "/var/aegir/.drush/provision/aegir.make"

# Safe mysql defaults
default[:mysql][:client][:packages] = ["mysql-client", "libmysqlclient-dev","ruby-mysql"]


# System users to create on the target
# Put the users authorized_keys as the value of this array (sorry, hash ;D)
default[:devudo][:users] = {
  'jon' => '',
  'devudo' => '',
}

