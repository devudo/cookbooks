#####################
# DEVUDO SHOPMASTER #
#####################

# shop.devudo.com is simply another aegir instance, but with super-powers.
# This server will fire up other servers with deployed devmaster instances.

node.set[:aegir][:profile] = "shopmaster"
node.set[:aegir][:makefile] = "#{node[:aegir][:dir]}/.drush/devudo_provision/build-shopmaster.make"
node.set[:aegir][:hostmaster_install_command] = "devmaster-install"

aegir_root = node[:aegir][:dir]
shopmaster_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

# First get Aegir (which also gets lamp and users)
include_recipe "devudo::aegir"

# Link up shop_provision.  We store this in the shopmaster repo now.
link "#{node[:aegir][:dir]}/.drush/shop_provision" do
  to "#{shopmaster_root}/profiles/shopmaster/drush/shop_provision"
end
