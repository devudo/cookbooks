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

# SHOPMASTER ONLY
#
#   Have the CTO create a new admin chef client for your server.
#
default[:knife][:node_name] = "#{node['fqdn']}.admin"
default[:knife][:chef_server_url] = 'http://198.61.196.221:4000'

# RACKSPACE
default[:rackspace][:rackspace_api_key] = 'e93596076f1a3bd404d6a8b790b8a96b'
default[:rackspace][:rackspace_api_username] = 'careernerd'
default[:rackspace][:rackspace_version] = 'v2'


default['php']['conf_dir']      = '/etc/php5/apache2'

default['mysql']['tunable']['max_allowed_packet']   = "64M"

# System users to create on the target
# Put the users authorized_keys as the value of this array
default[:devudo][:users] = {
  'jon' => '',
  'devudo' => '',
}

