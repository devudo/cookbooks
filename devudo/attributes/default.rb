default[:is_vagrant] = false

default[:aegir][:frontend] = node['fqdn']
default[:aegir][:fqdn] = node['fqdn']
default[:aegir][:client_email] = "jon@thinkdrop.net"

default[:aegir][:version] = "6.x-1.x"
default[:aegir][:authorized_keys] = ""
default[:aegir][:dir] = "/var/aegir"
default[:aegir][:db_host] = "localhost"
default[:aegir][:profile] = "hostmaster"
default[:aegir][:makefile] = "/var/aegir/.drush/provision/aegir.make"
default[:aegir][:hostmaster_install_command] = "hostmaster-install"

default[:aegir][:hosting_queue_runner_path] = '/usr/local/bin/hosting-queue-runner'
default[:aegir][:hosting_queue_runit_path] = '/etc/hosting-queue'

node.set['drush']['install_method'] = "wget"
node.set['drush']['install_dir'] = "/usr/share/drush"
node.set['drush']['command_path'] = "/usr/local/bin/drush"
node.set['drush']['version'] = "7.x-4.6"

# Making these blank by default so we can check for them
#default['newrelic']['server_monitoring']['license'] = ""
#default['newrelic']['application_monitoring']['license'] = ""
# doesn't work
node.set['newrelic']['server_monitoring']['license'] = ""
node.set['newrelic']['application_monitoring']['license'] = ""

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

# 5.4 or 5.4 ONLY... for now... it has to have a matching recipe,
# like recipe[devudo::php-5.4]
node.set['php']['version'] = '5.4'
node.set['php']['conf_dir']      = '/etc/php5/apache2'
#not set

#default['mysql']['tunable']['max_allowed_packet']   = "64M"
node.set['mysql']['tunable']['max_allowed_packet']   = "64M"
node.set['mysql']['bind_address'] = ""


# System users to create on the target
# Put the users authorized_keys as the value of this array
default[:devudo][:users] = {
  'jon' => '',
  'devudo' => '',
}


# Generate and deploy aegir ssh key to github
node.set['github_deploys']['deploy_user'] = "aegir"
node.set['github_deploys']['deploy_group'] = "aegir"
node.set['github_deploys']['deploy_home_path'] = "/var"

node.set['github_deploys']['github_api']['endpoint_path'] = "/user/keys"
node.set['github_deploys']['github_api']['username'] = "devudo-deploy"
node.set['github_deploys']['github_api']['email'] = "jon@devudo.com"
node.set['github_deploys']['github_api']['password'] = "wakkawakka123"
node.set['github_deploys']['github_api']['user_agent'] = "Devudo/1.0"
