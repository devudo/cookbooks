
# From http://community.aegirproject.org/installing/manual

# Aegir needs lamp
require_recipe "devudo::users"
require_recipe "devudo::lamp"

# Create the Aegir user
user "aegir" do
  comment "Aegir Hosting Management"
  home "/var/aegir"
  shell "/bin/bash"
  system true
end
group "www-data" do
  action :modify
  members "aegir"
  append true
end
directory "/var/aegir" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end
directory "/var/aegir/.drush" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end
directory "/var/aegir/.ssh" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end
directory "/var/aegir/config" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end

# Setup its ssh keys
cookbook_file "/var/aegir/.ssh/id_rsa" do
  source "ssh/aegir/id_rsa"
  action :create
  backup false
  owner "aegir"
  group "aegir"
  mode "0600"
end
cookbook_file "/var/aegir/.ssh/id_rsa.pub" do
  source "ssh/aegir/id_rsa.pub"
  action :create
  backup false
  owner "aegir"
  group "aegir"
  mode "0600"
end
cookbook_file "/var/aegir/.ssh/config" do
  source "ssh/aegir/config"
  action :create
  backup false
  owner "aegir"
  group "aegir"
  mode "0600"
end


# prepare drush commands folder
directory "/usr/share/drush/commands" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end

# Make sure the Aegir user is allowed to restart apache
package 'sudo' do
  action :install
end
cookbook_file "/etc/sudoers.d/aegir" do
  source "sudoers.d/aegir"
  action :create
  backup false
  owner "root"
  group "root"
  mode 00440
end

# symlink apache config
link "/etc/apache2/conf.d/aegir.conf" do
  to "/var/aegir/config/apache.conf"
end

# set the root MYSQL password
# (eg. platforms other than debian/ubuntu & drop-in mysql replacements)
execute "assign-root-password" do
  command "\"#{node[:mysql][:mysqladmin_bin]}\" -u root password \"#{node[:mysql][:server_root_password]}\""
  action :run
  only_if "\"#{node[:mysql][:mysql_bin]}\" -u root -e 'show databases;'"
end
require_recipe "devudo::mysql_secure_installation"


# Get provision.
git "/var/aegir/.drush/provision" do
  repository "http://git.drupal.org/project/provision.git"
  reference "6.x-1.9"
  action :export
  user "aegir"
  group "aegir"
end

bash "Start the Aegir install process" do
  not_if "drush @hostmaster status"
  user "aegir"
  group "www-data"
  environment ({'HOME' => "#{node[:aegir][:dir]}"})
  cwd "#{node[:aegir][:dir]}"
  code <<-EOH
  drush hostmaster-install #{node[:aegir][:frontend]} \
  --site="#{node[:aegir][:frontend]}" \
  --aegir_host="#{node[:aegir][:fqdn]}" \
  --http_service_type="apache" \
  --aegir_db_user="root" \
  --aegir_db_pass="#{node[:mysql][:server_root_password]}" \
  --db_service_type="mysql" \
  --db_port=3306 \
  --aegir_db_host="#{node[:aegir][:db_host]}" \
  --client_email="#{node[:aegir][:client_email]}" \
  --version="#{node[:aegir][:version]}" \
  --script_user="aegir" \
  --web_group="www-data" \
  --profile=hostmaster \
  --yes
  EOH
  end