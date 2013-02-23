
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
  to "/var/aegir/apache.conf"
end

# Get provision.
execute "Download provision" do
  # If drush runs as root, provision is not installed yet.
  only_if "drush"
  command "drush dl provision-6.x-1.9 -y --destination=/var/aegir/.drush"
end

# Install hostmaster
# @TODO: Figure out how to use an attribute to decide which version to install.
execute "Install Hostmaster" do
  # Only install if @hostmaster is not found yet.
  #not_if "drush @hostmaster status"
  #command "drush hostmaster-install"
end
