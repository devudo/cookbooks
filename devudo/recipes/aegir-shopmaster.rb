#####################
# DEVUDO SHOPMASTER #
#####################

# sales.devudo.com is simply another aegir instance, but with super-powers.
# This server will fire up other servers with deployed devmaster instances.

# First get Aegir (which also gets lamp and users)

node.set[:aegir][:profile] = "hostmaster"
node.set[:aegir][:makefile] = "/var/aegir/.drush/provision/aegir.make"

include_recipe "devudo::aegir"

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
git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/devel" do
    repository "http://git.drupal.org/project/devel.git"
    action :export
    reference "6.x-1.27"
    user "aegir"
end
git "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/sshkey" do
    repository "http://git.drupal.org/project/sshkey.git"
    reference "6.x-2.0"
    action :sync
    user "aegir"
end
