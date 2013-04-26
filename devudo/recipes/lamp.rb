#
# Base LAMPd development server
#
include_recipe "apt"


# PHP must be included after apache is available, because
# the /etc/php5/apache2 folder doesn't exist yet.
# We are doing a little magic to get our desired version of php installed...
# do not forget to add the version number to attributes.

# If not 5.4 force to 5.3...  php::default has 5.3.10 for some reason.
# @TODO: figure out why my attributes from default.rb don't override php recipe.
if node[:php][:version] != "5.4"
  node.set[:php][:version] = "5.3"
end

directory "/etc/php5/apache2"

include_recipe "devudo::php-#{node[:php][:version]}"
#include_recipe "drush::install_console_table"
include_recipe "drush"

package "php5-curl"
package "git-core"

# Get Rackspace commands
git "/usr/share/drush/commands/rackspace_drush" do
  repository "http://github.com/devudo/rackspace_drush.git"
  action :sync
  enable_submodules true
end

# Save a DNS record for myself!
drush "rackspace-dns-create --rackspace_username=#{node[:rackspace][:rackspace_api_username]} --rackspace_api_key=#{node[:rackspace][:rackspace_api_key]} --hostname=#{node[:fqdn]} --ip_address=#{node[:ipaddress]}" do
  not_if {
    File.exists?("/etc/ip_address")
  }
  user "root"
  group "root"
  cwd "/"
end

# add a file to indicate the ipaddress
file "/etc/ip_address" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  content node[:ipaddress]
end


##### OLD TOP


include_recipe "mysql::server"
include_recipe "devudo::mysql_secure_installation"

# If we have keys, install newrelic

if node['newrelic']['server_monitoring']['license'] != ""
  include_recipe "newrelic"
end
if node['newrelic']['application_monitoring']['license'] != ""
  include_recipe "newrelic"
end

# Install required apt packages.
# @TODO: Make these a default attribute
%w{ apache2 postfix sudo rsync unzip vim }.each do |package_name|
  package package_name
end

service "apache2" do
  service_name "apache2"
  restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  supports [:restart, :reload, :status]
  action :enable
end

# Enable mod_rewrite
execute "Enable mod_rewrite" do
  command "a2enmod rewrite"
  notifies :restart, "service[apache2]", :immediately
end

package "libapache2-mod-php5"



# additional php packages
%w{ php5 php5-cli php5-gd php5-mysql php-pear php5-curl php5-mcrypt }.each do |package_name|
  package package_name
end


# add our recursive git pull tweak.
file "/usr/local/bin/git-pull-recursive" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  content 'find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'
end
