default[:aegir][:frontend] = node['fqdn']
default[:aegir][:fqdn] = node['fqdn']
default[:aegir][:client_email] = "jon@thinkdrop.net"

default[:aegir][:version] = "6.x-1.x"
default[:aegir][:authorized_keys] = ""
default[:aegir][:dir] = "/var/aegir"
default[:aegir][:db_host] = "localhost"
default[:aegir][:profile] = "hostmaster"
default[:aegir][:makefile] = "/var/aegir/.drush/provision/aegir.make"
default[:aegir][:working_copy] = "1"
default[:aegir][:hostmaster_install_command] = "hostmaster-install"

default[:aegir][:hosting_queue_runner_path] = '/usr/local/bin/hosting-queue-runner'
default[:aegir][:hosting_queue_runit_path] = '/etc/hosting-queue'

default['drush']['install_method'] = "wget"
default['drush']['install_dir'] = "/usr/share/drush"
default['drush']['command_path'] = "/usr/local/bin/drush"
default['drush']['version'] = "7.x-4.6"


default['php']['conf_dir']      = '/etc/php5/apache2'


# System users to create on the target
# Put the users authorized_keys as the value of this array
default[:devudo][:users] = {
  'jon' => '',
  'devudo' => '',
}

