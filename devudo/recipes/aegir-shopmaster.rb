#####################
# DEVUDO SHOPMASTER #
#####################

# sales.devudo.com is simply another aegir instance, but with super-powers.
# This server will fire up other servers with deployed devmaster instances.


node.set[:aegir][:profile] = "shopmaster"
node.set[:aegir][:makefile] = "#{node[:aegir][:dir]}/.drush/devudo_provision/build-shopmaster.make"
node.set[:aegir][:hostmaster_install_command] = "devmaster-install"


aegir_root = node[:aegir][:dir]
shopmaster_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

# First get Aegir (which also gets lamp and users)
include_recipe "devudo::aegir"

# don't forget our shop_provision
git "#{node[:aegir][:dir]}/.drush/shop_provision" do
  repository "git@github.com:devudo/shop_provision.git"
  reference "master"
  action :sync
  enable_submodules true
  user "aegir"
  group "aegir"
end


# @TODO: How to update all working-copy git repos
# within shopmaster!
# This repo was originally created with the makefile by devmaster-install
# Make sure the repo is up to date
#git shopmaster_root do
#  repository "git@github.com:devudo/shopmaster.git"
#  reference "6.x-1.x"
#  action :sync
#  enable_submodules true
#  user "aegir"
#  group "aegir"
#end
