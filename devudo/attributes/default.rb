default[:aegir][:frontend] = node['fqdn']
default[:aegir][:fqdn] = node['fqdn']
default[:aegir][:client_email] = "jon@thinkdrop.net"

default[:aegir][:version] = "6.x-1.x"
default[:aegir][:authorized_keys] = ""
default[:aegir][:dir] = "/var/aegir"
default[:aegir][:db_host] = "localhost"
default[:aegir][:profile] = "hostmaster"
default[:aegir][:makefile] = "/var/aegir/.drush/provision/aegir.make"

# Needs to be set for chef SOLO only.  For chef server, it will be random
# @TODO! Remove this from cookbook, put it in vagrantfile
node[:mysql][:server_root_password] = "abcd12345678"
node[:mysql][:server_debian_password] = "abcd12345678"
node[:mysql][:server_repl_password] = "abcd12345678"

# System users to create on the target
# Put the users authorized_keys as the value of this array
default[:devudo][:users] = {
  'jon' => '',
  'devudo' => '',
}

