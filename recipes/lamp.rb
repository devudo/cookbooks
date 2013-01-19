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

# Setup Drush
git "Install Drush" do
  repository "http://git.drupal.org/project/drush.git"
  reference "7.x-4.6"
  action :sync
  destination "/usr/share/drush"
end
link "/usr/local/bin/drush" do
  to "/usr/share/drush/drush"
end
execute "Run Drush to ensure it works." do
  command "sudo drush"
end