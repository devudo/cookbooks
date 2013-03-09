####################
# DEVUDO DEVMASTER #
####################

# Force Override this node's attributes
node.override[:aegir][:profile] = "devmaster"
node.override[:aegir][:makefile] = "/var/aegir/.drush/devudo_provision/devmaster.make"

aegir_root = node[:aegir][:dir]
devmaster_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

log "[DEVUDO] Preparing devmaster instance at #{devmaster_root}"

# First get Aegir (which also gets lamp and users)
include_recipe "devudo::aegir"

# Make sure repo is up to date
git devmaster_root do
  repository "git@github.com:devudo/devmaster.git"
  reference "6.x-1.x"
  action :sync
  user "aegir"
  group "aegir"
end

# Provision tools
git "#{aegir_root}/.drush/provision_git" do
    repository "http://git.drupal.org/project/provision_git.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end
git "#{aegir_root}/.drush/devshop_provision" do
    repository "http://git.drupal.org/project/devshop_provision.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end
git "#{aegir_root}/.drush/provision_logs" do
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
