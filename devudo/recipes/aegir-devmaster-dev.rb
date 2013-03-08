#################################
# DEVUDO DEVMASTER DEVELOPMENT! #
#################################
# This recipe essentially just runs aegir-devmaster and then
# replaces the paths with symbolic links to the /source folder.

include_recipe "devudo::aegir"

link "/var/chef/cookbooks" do
  to "/vagrant/cookbooks"
end

