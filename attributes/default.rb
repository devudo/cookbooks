default[:aegir][:frontend] = node['fqdn']
default[:aegir][:fqdn] = node['fqdn']
default[:aegir][:client_email] = "jon@thinkdrop.net"

default[:aegir][:version] = "6.x-1.x"
default[:aegir][:authorized_keys] = ""
default[:aegir][:dir] = "/var/aegir"
default[:aegir][:db_host] = "localhost"

default[:mysql][:server_root_password] = "abcd12345678"
default[:mysql][:mysql_bin]            = "/usr/bin/mysql"
default[:mysql][:mysqladmin_bin]       = "/usr/bin/mysqladmin"

default[:devudo][:users] = {
  'jon' => '',
}

