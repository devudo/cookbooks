
# From http://community.aegirproject.org/installing/manual

# Aegir needs lamp
include_recipe "devudo::users"
include_recipe "devudo::lamp"
include_recipe "devudo::aegir-user"


# symlink apache config
link "/etc/apache2/conf.d/aegir.conf" do
  to "#{node[:aegir][:dir]}/config/apache.conf"
end

# Get provision.
drush "dl provision-6.x-1.9 --destination=#{node[:aegir][:dir]}/.drush" do
  not_if do
    File.exists?("#{node[:aegir][:dir]}/.drush/provision")
  end
end

# Devudo Provision for all servers
git "#{node[:aegir][:dir]}/.drush/devudo_provision" do
    repository "git@github.com:devudo/devudo_provision.git"
    action :sync
    user "aegir"
end




# @TODO Make this its own recipe with just enough attributes for us.
# @TODO: Actually check if @hostmaster is installed.

# @TODO: Find out why we always end up on the Install page on first run!
#   devmaster-install should verify itself...
# THIS WORKS when done manually from the command line.
aegir_install_command = <<-EOH
  drush #{node[:aegir][:hostmaster_install_command]} #{node[:aegir][:frontend]} \
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

log aegir_install_command

bash "aegir-install" do
  not_if do
    File.exists?("#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}")
  end
  user "aegir"
  group "www-data"
  environment 'HOME' => "#{node[:aegir][:dir]}"
  cwd "#{node[:aegir][:dir]}"
  code aegir_install_command
end

bash "aegir-update" do
  cwd "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"
  user "aegir"
  group "aegir"
  environment 'HOME' => "#{node[:aegir][:dir]}"
  code "git-pull-recursive"
end

# Hosting queue runner
# include_recipe "devudo::hosting-queue-runner"

#THIS IS NOW FAILING!
#[2013-05-07T22:56:55+00:00] INFO: Processing service[runit] action nothing (runit::default line 20)
#[2013-05-07T22:56:55+00:00] INFO: Processing execute[start-runsvdir] action nothing (runit::default line 24)
#[2013-05-07T22:56:55+00:00] INFO: Processing execute[runit-hup-init] action nothing (runit::default line 33)
#[2013-05-07T22:56:55+00:00] INFO: Processing package[runit] action install (runit::default line 93)
#[2013-05-07T22:56:55+00:00] INFO: Processing service[hosting-queue] action nothing (dynamically defined)
#[2013-05-07T22:56:55+00:00] INFO: Processing runit_service[hosting-queue] action enable (devudo::aegir line 83)
#
#================================================================================
#Error executing action `enable` on resource 'runit_service[hosting-queue]'
#================================================================================
#
#NameError
#---------
#Cannot find a resource for load_new_resource_state on ubuntu version 12.04
#
#Cookbook Trace:
#---------------
#/var/chef/cookbooks/runit/libraries/provider_runit_service.rb:93:in `action_enable'
#
#
