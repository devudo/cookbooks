
# From http://community.aegirproject.org/installing/manual

# Aegir needs lamp
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

# Enable mod_rewrite
exec "Enable mod_rewrite" do
  command "a2enmod rewrite"
end
