#####################
# DEVUDO SHOPMASTER #
#####################

# sales.devudo.com is simply another aegir instance, but with super-powers.
# This server will fire up other servers with deployed devmaster instances.

# First get Aegir (which also gets lamp and users)

# @TODO: Figure out how to change attributes here
require_recipe "devudo::aegir"

# Add devudo hotness
# prepare drush commands folder
directory "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end

# Hostmaster enhancements
git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/shop_hosting" do
    repository "git@github.com:devudo/shop_hosting.git"
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
git "/var/aegir/.drush/shop_provision" do
    repository "git@github.com:devudo/shop_provision.git"
    action :sync
    user "aegir"
end
git "/var/aegir/.drush/provision_logs" do
    repository "http://git.drupal.org/project/provision_logs.git"
    reference "6.x-1.x"
    action :sync
    user "aegir"
end