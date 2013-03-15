####################
# DEVUDO DEVMASTER #
####################
node.set[:aegir][:profile] = "devmaster"
node.set[:aegir][:makefile] = "#{node[:aegir][:dir]}/.drush/devudo_provision/build-devmaster.make"
node.set[:aegir][:hostmaster_install_command] = "devmaster-install"

aegir_root = node[:aegir][:dir]
devmaster_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

log "[DEVUDO] Preparing devmaster instance at #{devmaster_root}"

# First get Aegir (which also gets lamp and users)
include_recipe "devudo::aegir"

execute "Aegir: Save SSH key to a variable" do
  user "aegir"
  group "aegir"
  command 'drush @hostmaster vset devshop_public_key "$(cat ~/.ssh/id_rsa.pub)" --yes'
  environment ({'HOME' => "#{node[:aegir][:dir]}"})
  cwd "#{node[:aegir][:dir]}"
end


# This repo was originally created with the makefile by devmaster-install
# Make sure the repo is up to date
git devmaster_root do
  repository "git@github.com:devudo/devmaster.git"
  reference "6.x-1.x"
  action :sync
  enable_submodules true
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
#git "#{node[:aegir][:dir]}/.drush/provision_solr" do
#    repository "http://git.drupal.org/project/provision_solr.git"
#    reference "6.x-1.x"
#    action :sync
#    user "aegir"
#end
