#
# Base LAMPd development server
#
include_recipe "apt"
include_recipe "mysql::server"
include_recipe "devudo::mysql_secure_installation"

# Install required apt packages.
# @TODO: Make these a default attribute
%w{ apache2 postfix sudo rsync git-core unzip vim }.each do |package_name|
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
end

# PHP must be included after apache is available, because
# the /etc/php5/apache2 folder doesn't exist yet.
package "libapache2-mod-php5"
include_recipe "php"
include_recipe "drush"

# additional php packages
%w{ php5 php5-cli php5-gd php5-mysql php-pear php5-curl }.each do |package_name|
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
