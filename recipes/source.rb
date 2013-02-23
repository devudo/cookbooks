

directory "/src" do
  owner "root"
  group "devs"
  mode "0775"
  action :create
  recursive true
end

git "DevShop Provision Source" do
    repository "http://git.drupal.org/project/devshop_provision.git"
    reference "6.x-1.x"
    action :sync
    destination "/src/devshop_provision"
    owner "root"
    group "devs"
    mode "0775"
end