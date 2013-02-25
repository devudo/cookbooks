
# DEVMASTER!

# First get Aegir (which also gets lamp and users)

# @TODO: If we were to change the attributes that aegir.rb is expecting here,
# we could tell the aegir recipe to install devmaster instead of hostmaster!
require_recipe "devudo::aegir"


# prepare drush commands folder
directory "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end

# Hostmaster enhancements
# @TODO: All unneccessary when we get a devmaster make file.
git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/devshop_hosting" do
    repository "http://git.drupal.org/project/devshop_hosting.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end
git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/ctools" do
    repository "http://git.drupal.org/project/ctools.git"
    reference "6.x-1.10"
    action :sync
    user "aegir"
end
git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/hosting_solr" do
    repository "http://git.drupal.org/project/hosting_solr.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end
git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/hosting_logs" do
    repository "http://git.drupal.org/project/hosting_logs.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
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
git "/var/aegir/.drush/provision_solr" do
    repository "http://git.drupal.org/project/provision_solr.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end