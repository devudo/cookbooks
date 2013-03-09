####################
# DEVUDO DEVMASTER #
####################

# First get Aegir (which also gets lamp and users)
node.override[:aegir][:profile] = "devmaster"
node.override[:aegir][:makefile] = "/var/aegir/.drush/devudo_provision/devmaster.make"
include_recipe "devudo::aegir"

aegir_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

# Make sure repo is up to date
git aegir_root do
  repository "git@github.com:devudo/devmaster.git"
  reference "6.x-1.x"
  action :sync
  enable_submodules true
  user "aegir"
  group "aegir"
end

# Provision tools
git "/var/aegir/.drush/provision_git" do
    repository "http://git.drupal.org/project/provision_git.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end
git "/var/aegir/.drush/devshop_provision" do
    repository "http://git.drupal.org/project/devshop_provision.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end
git "/var/aegir/.drush/provision_logs" do
    repository "http://git.drupal.org/project/provision_logs.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end
#git "/var/aegir/.drush/provision_solr" do
#    repository "http://git.drupal.org/project/provision_solr.git"
#    reference "6.x-1.x"
#    action :sync
#    user "aegir"
#end
