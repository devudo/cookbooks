
# From http://community.aegirproject.org/installing/manual

#
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
  # RESOURCE sudo DOES NOT EXIST
  
  #sudo "apache2" do
  #  user "aegir"
  #  commands ["/usr/sbin/apache2ctl"]
  #  host "ALL"
  #  nopasswd true
  #end

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

#  file "/etc/sudoers.d/aegir" do
#    owner "root"
#    group "root"
#    mode 00440
#    action :create
#    content "Defaults:aegir  !requiretty
#aegir ALL=NOPASSWD: /usr/sbin/apache2ctl"
#  end

  # symlink apache config
  link "/etc/apache2/conf.d/aegir.conf" do
    to "/var/aegir/apache.conf"
  end

# a2enmod rewrite
# ln -s /var/aegir/config/apache.conf /etc/apache2/conf.d/aegir.conf
# Create a file at /etc/sudoers.d/aegir and add the following:
#
#Defaults:aegir  !requiretty
#aegir ALL=NOPASSWD: /usr/sbin/apache2ctl
#After saving, change the permissions on the file:
#
#chmod 0440 /etc/sudoers.d/aegir