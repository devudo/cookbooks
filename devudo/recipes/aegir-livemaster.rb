#
# This is new and experimental (to me)
# Based mostly on https://github.com/yevgenko/cookbook-aegir/blob/master/recipes/default.rb



# First get Aegir (which also gets lamp and users)
include_recipe "devudo::users"
include_recipe "devudo::aegir-user"

node.set['mysql']['bind_address'] = ''
node.set['nginx']['server_names_hash_bucket_size'] = ''  # THIS IS HANDLED IN AEGIR NGINX TEMPLATE

include_recipe "apt"
include_recipe "php-fpm"
include_recipe "nginx"
include_recipe "mysql::server"
include_recipe "devudo::mysql_secure_installation"

server_fqdn = node.fqdn

# Required php extensions
%w{php5-cli php5-gd php5-mysql php-apc php-pear php5-curl }.each do |package|
  package "#{package}" do
    action :upgrade
  end
end

# Other stuff
%w{git-core git-doc vim drush postfix rsync unzip bzr patch curl}.each do |package|
  package "#{package}" do
    action :upgrade
  end
end

# Make sure the Aegir user is allowed to restart Nginx
sudo "nginx" do
  user "aegir"
  commands ["/etc/init.d/nginx"]
  host "ALL"
  nopasswd true # true prepends the runas_spec with NOPASSWD
end

# symlink nginx config
link "/etc/nginx/conf.d/aegir.conf" do
  to "#{node[:aegir][:dir]}/config/nginx.conf"
  notifies :restart, resources(:service => "nginx", :service => "php5-fpm")
end

# Grant access to this server from the devmaster_parent
execute "devmaster-database-grant" do
  command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" < \"GRANT ALL PRIVILEGES ON *.* TO root@#{node['devudo']['devmaster_parent_ip']} IDENTIFIED BY '#{node['mysql']['server_root_password']}' WITH GRANT OPTION; FLUSH PRIVILEGES;\""
  action :nothing
end
# @TODO!!! Grant SQL Access to this livemaster's owner devmaster
# GRANT ALL PRIVILEGES ON *.* TO root@aegir_server_IP IDENTIFIED BY 'some_pass' WITH GRANT OPTION; FLUSH PRIVILEGES;
# GRANT ALL PRIVILEGES ON *.* TO root@166.78.3.181 IDENTIFIED BY 'l24866yB24l06NZNN591' WITH GRANT OPTION; FLUSH PRIVILEGES;

