
# From http://community.aegirproject.org/installing/manual

# Aegir needs lamp
include_recipe "devudo::users"
include_recipe "devudo::lamp"


# Create the Aegir user
user "aegir" do
  comment "Aegir Hosting Management"
  home "/var/aegir"
  shell "/bin/bash"
  system true
end
# Add aegir to www-data group
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

# Here we take the attribute and save the authorized_keys file.
# Right now this is handled in shop_hosting so the web app
# can control who is authorized.
file "/var/aegir/.ssh/authorized_keys" do
  content node[:aegir][:authorized_keys]
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

# Get provision.
git "/var/aegir/.drush/provision" do
  repository "http://git.drupal.org/project/provision.git"
  reference "6.x-1.9"
  action :export
  user "aegir"
  group "aegir"
end

# Devudo Provision
git "/var/aegir/.drush/devudo_provision" do
    repository "git@github.com:devudo/devudo_provision.git"
    action :sync
    user "aegir"
end

# @TODO Make this its own recipe with just enough attributes for us.
bash "Start the Aegir install process" do
  not_if do
    File.exists?("#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}")
  end
  user "aegir"
  group "aegir"
  environment ({'HOME' => "#{node[:aegir][:dir]}"})
  cwd "#{node[:aegir][:dir]}"
  code <<-EOH
  drush #{node[:aegir][:profile]}-install #{node[:aegir][:frontend]} \
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
  --profile="#{node[:aegir][:profile]}" \
  --makefile="#{node[:aegir][:makefile]}" \
  --working-copy \
  --yes
  EOH
end
#
#bash "Save SSH key to a variable" do
#  user "aegir"
#  group "aegir"
#  code 'drush @hostmaster vset devshop_public_key "$(cat ~/.ssh/id_rsa.pub)" --yes'
#end
