#####################
# DEVUDO SHOPMASTER #
#####################

# sales.devudo.com is simply another aegir instance, but with super-powers.
# This server will fire up other servers with deployed devmaster instances.


node.set[:aegir][:profile] = "hostmaster"
node.set[:aegir][:makefile] = "/var/aegir/.drush/devudo_provision/shopmaster.make"

aegir_root = node[:aegir][:dir]
shopmaster_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

# First get Aegir (which also gets lamp and users)
include_recipe "devudo::aegir"

# This repo was originally created with the makefile by devmaster-install
# Make sure the repo is up to date
git shopmaster_root do
  repository "git@github.com:devudo/shopmaster.git"
  reference "6.x-1.x"
  action :sync
  enable_submodules true
  user "aegir"
  group "aegir"
end
