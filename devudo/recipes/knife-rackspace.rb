
#include_recipe "apt"
#include_recipe "devudo::aegir-user"


# knife rackspace server create
# Its a gem, but dang it has a lot of needs.


# APR 10 attempt
# FROM http://nokogiri.org/tutorials/installing_nokogiri.html
#sudo apt-get install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby libxslt-dev libxml2-dev
#
#sudo apt-get install make
#sudo gem install nokogiri
#sudo gem install fog --version 1.8.0
#sudo gem install knife-rackspace
# IT WORKED!!!!!!


%w{ make ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby libxslt-dev libxml2-dev }.each do |package_name|
  package package_name
end

gem_package "nokogiri" do
  options("--no-rdoc --no-ri")
end
gem_package "fog" do
  options("--version 1.8.0 --no-rdoc --no-ri")
end
gem_package "knife-rackspace" do
  options("--no-rdoc --no-ri")
end

# Prepare to make a chef client.
directory "/etc/chef" do
  action :create
  recursive true
end
directory "#{node[:aegir][:dir]}/.chef/" do
  action :create
  recursive true
  owner "aegir"
  group "aegir"
end
cookbook_file "/etc/chef/validation.pem" do
    source "validation.pem"
    mode "0664"
end
template "#{node[:aegir][:dir]}/.chef/knife.rb" do
    source "knife.rb.erb"
    owner "aegir"
    group "aegir"
    mode "0664"
end

file "/#{node[:aegir][:dir]}/.chef/#{node[:fqdn]}.admin.pem" do
  content "INSERT PRIVATE KEY HERE"
  mode "0600"
  owner "aegir"
  group "aegir"
  action :create_if_missing
end
