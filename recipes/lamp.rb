#
#
#

# Install required apt packages.
%w{ apache2 php5 php5-cli php5-gd php5-mysql php-pear php5-curl mysql-server postfix sudo rsync git-core unzip }.each do |package_name|
  package package_name
end

service "apache2" do
  service_name "apache2"
  restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  supports [:restart, :reload, :status]
  action :enable
end

php_pear "drush" do
  action :install_if_missing
  channel "pear.drush.org"
  version "4.6.0"
end
