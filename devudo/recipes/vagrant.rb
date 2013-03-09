

directory "/var/chef" do
  owner "root"
  group "root"
  mode 00755
  action :create
  recursive true
end

link "/var/chef/cookbooks" do
  to "/vagrant/cookbooks"
end
