#################################
# DEVUDO DEVMASTER DEVELOPMENT! #
#################################
# This recipe essentially just runs aegir-devmaster and then
# replaces the paths with symbolic links to the /source folder.

include_recipe "devudo::aegir-devmaster"
#
## @TODO: Figure out a good way to do this... makefiles?
#directory "#{node[:aegir][:dir]}/devmaster-6.x-1.x/sites/all/modules/hosting_drush_aliases" do
#  action :delete
#end
#link "#{node[:aegir][:dir]}/devmaster-6.x-1.x/sites/all/modules/hosting_drush_aliases" do
#  to "/source/drupal/hosting_drush_aliases"
#end
