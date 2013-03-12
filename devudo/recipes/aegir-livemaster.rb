
# First get Aegir (which also gets lamp and users)
include_recipe "devudo::users"

include_recipe "apt"
include_recipe "php-fpm"
include_recipe "nginx"
server_fqdn = node.fqdn

# Required php extensions
%w{php5-cli php5-gd php5-mysql php-apc}.each do |package|
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
  
# Create the Aegir user
user "aegir" do
  comment "Aegir Hosting Management"
  home "#{node[:aegir][:dir]}"
  shell "/bin/bash"
  system true
end
group "www-data" do
  action :modify
  members "aegir"
  append true
end
directory "#{node[:aegir][:dir]}" do
  owner "aegir"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

# Make sure the Aegir user is allowed to restart Nginx
sudo "nginx" do
  user "aegir"
  commands ["/etc/init.d/nginx"]
  host "ALL"
  nopasswd true # true prepends the runas_spec with NOPASSWD
end
bash "Tweak nginx.conf file and symlink aegir in place" do
    cwd "/etc/nginx"
    code <<-EOH
    sed -i 's/server_names_hash_bucket_size/#server_names_hash_bucket_size/' nginx.conf
    sed -i 's/gzip_comp_level/#gzip_comp_level/' nginx.conf
    sed -i 's/gzip_http_version/#gzip_http_version/' nginx.conf
    sed -i 's/gzip_min_length/#gzip_min_length/' nginx.conf
    sed -i 's/gzip_types/#gzip_types/' nginx.conf
    sed -i 's/gzip_proxied/#gzip_proxied/' nginx.conf
    ln -s #{node[:aegir][:dir]}/config/nginx.conf /etc/nginx/conf.d/aegir.conf
    EOH
    notifies :restart, resources(:service => "nginx", :service => "php5-fpm")
end