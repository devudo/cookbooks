
# sales.devudo.com is simply another aegir instance, but with super-powers.
# This server will fire up other servers with deployed devmaster instances.

# First get Aegir (which also gets lamp and users)

# @TODO: Figure out how to change attributes here
require_recipe "devudo::aegir"

# Add devudo hotness
directory "/var/aegir/src" do
  owner "aegir"
  group "aegir"
  mode "0755"
  action :create
  recursive true
end


git "Devudo Hosting Source" do
    repository "git@github.com:devudo/devudo_hosting.git"
    reference "6.x-1.x"
    action :sync
    destination "/var/aegir/src/devudo_hosting"
end
# Symlink to hostmaster
# @TODO: User attributes
link "/var/aegir/hostmaster-6.x-1.x/sites/all/modules/devudo_hosting" do
  to "/var/aegir/src/devudo_hosting"
end


git "Devudo Provision Source" do
    repository "git@github.com:devudo/devudo_provision.git"
    reference "6.x-1.x"
    action :sync
    destination "/var/aegir/src/devudo_provision"
end
# Symlink to hostmaster
# @TODO: User attributes
link "/var/aegir/.drush/devudo_provision" do
  to "/var/aegir/src/devudo_provision"
end
