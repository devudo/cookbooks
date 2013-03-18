#
# Use this file for your local testing
#

include_recipe "apt"
include_recipe "php"
include_recipe "drush"

drush "dl provision-6.x-1.9" do
  user 'root'
  cwd '/root'
  only_if "drush"  # This is sufficient because root# drush will fail if provision is installed.
end
