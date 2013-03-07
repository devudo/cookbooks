####################
# DEVUDO DEVMASTER #
####################

# First get Aegir (which also gets lamp and users)
<<<<<<< HEAD
node.override[:aegir][:profile] = "devmaster"
include_recipe "devudo::aegir"
=======
require_recipe "devudo::aegir"
>>>>>>> c5d00abec973384a1ab49ca6a512f12a1257ac8a

aegir_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

# Make sure repo is up to date
git aegir_root do
  repository "git@github.com:devudo/devmaster.git"
  reference "6.x-1.x"
  action :sync
  user "aegir"
  group "aegir"
end

# give access to all our users.
userlist = node[:devudo][:users]

group "devs" do
  action :create
  group_name "devs"
end


# prepare aegir modules folder
directory "#{aegir_root}/sites/all/modules/" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end

# Hostmaster enhancements
# @TODO: All unneccessary when we get a devmaster make file.
#git "#{aegir_root}/sites/all/modules/devshop_hosting" do
#    repository "http://git.drupal.org/project/devshop_hosting.git"
#    reference "6.x-1.x"
#    action :sync
#    user "aegir"
#end
#git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/ctools" do
#    repository "http://git.drupal.org/project/ctools.git"
#    reference "6.x-1.10"
#    action :sync
#    user "aegir"
#end
#git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/hosting_solr" do
#    repository "http://git.drupal.org/project/hosting_solr.git"
#    reference "6.x-1.x"
#    action :sync
#    user "aegir"
##end
#git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/hosting_logs" do
#    repository "http://git.drupal.org/project/hosting_logs.git"
#    reference "6.x-1.x"
#    action :sync
#    user "aegir"
#end

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
