#
# This is new and experimental (to me)
# Based mostly on https://github.com/yevgenko/cookbook-aegir/blob/master/recipes/default.rb



# First get Aegir (which also gets lamp and users)
include_recipe "devudo::users"
include_recipe "devudo::aegir-user"

include_recipe "apt"
include_recipe "php-fpm"
include_recipe "nginx"
include_recipe "mysql::server"

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

#bash "Tweak nginx.conf file and symlink aegir in place" do
#    cwd "/etc/nginx"
#    code <<-EOH
#    sed -i 's/gzip_comp_level/#gzip_comp_level/' nginx.conf
#    sed -i 's/gzip_http_version/#gzip_http_version/' nginx.conf
#    sed -i 's/gzip_min_length/#gzip_min_length/' nginx.conf
#    sed -i 's/gzip_types/#gzip_types/' nginx.conf
#    sed -i 's/gzip_proxied/#gzip_proxied/' nginx.conf
#    ln -s nginx /etc/nginx/conf.d/aegir.conf
#    EOH
#    notifies :restart, resources(:service => "nginx", :service => "php5-fpm")
#end