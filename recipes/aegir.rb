

git "DevShop Provision Source" do
    repository "http://git.drupal.org/project/devshop_provision.git"
    reference "6.x-1.x"
    action :checkout
    destination "/home/jon/"
end