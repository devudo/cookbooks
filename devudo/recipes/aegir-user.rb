
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
Directory "/var/aegir/.drush" do
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

include_recipe "ssh_known_hosts"
ssh_known_hosts_entry 'github.com'
include_recipe "github-deploys"

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

# @TODO: Utilize sudo cookbook
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
