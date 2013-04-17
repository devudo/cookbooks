#
# Jacked from http://community.opscode.com/cookbooks/tomcat-solr
#

# Install tomcat7
package "tomcat7" do
  action :install
end

# Add solr war to tomcat webapps
cookbook_file "/usr/share/solr-3.6.2.war" do
  source "solr-3.6.2.war"
  owner "root"
  group "root"
  mode "0644"
  #      notifies :restart, resources(:service => "tomcat7") 
end

# Add tomcat7 user to aegir group (it needs to write the data folder)
group "aegir" do
  action :modify
  members "tomcat6"
  append true
end

# Remove Catalina/localhost and symlink to aegir config folder
execute "rm -rf /var/lib/tomcat7/conf/Catalina/localhost" do
  action :run
  notifies :create, 'link[/var/lib/tomcat7/conf/Catalina/localhost]', :immediately
end
link "/var/lib/tomcat7/conf/Catalina/localhost" do
  to "#{node[:aegir][:dir]}/config/tomcat"
  action :nothing
end

# ~/config/tomcat will symlink to ~/config/server_NAME/tomcat,
# just like ~/config/apache symlinks to ~/config/server_NAME/apache
# This is when running provision-verify on a server, so it is handled
# in provision_solr, NOT HERE!

#
# AEGIR setup
#
#group "aegir" do
#  action :modify
#  members "tomcat6"
#  append true
#end
#group "tomcat6" do
#  action :modify
#  members "aegir"
#  append true
#end

# Get hosting and provision solr mods
node.set[:aegir][:profile] = 'devmaster'
devmaster_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

git "#{node[:aegir][:dir]}/.drush/provision_solr" do
  repository "http://git.drupal.org/project/provision_solr.git"
  reference "6.x-1.x"
  action :sync
  user "aegir"
  group "aegir"
end
git "#{devmaster_root}/sites/all/modules/hosting_solr" do
  repository "http://git.drupal.org/project/hosting_solr.git"
  reference "6.x-1.x"
  action :sync
  user "aegir"
  group "aegir"
end

# drush "@hostmaster en hosting_solr"
  
# configuring tomcat
#template "/var/lib/tomcat7/conf/Catalina/localhost/solr.xml" do
#    source "tomcat_solr.xml.erb"
#    owner "root"
#    group "tomcat"
#    mode "0664"
#end
#
## creating solr home and solr core
#directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}" do
#    owner "root"
#    group "tomcat"
#    mode "0777"
#    action :create
#    recursive true
#end
#
#directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf" do
#    owner "root"
#    group "tomcat"
#    mode "0777"
#    action :create
#end
#
## configuring solr
#template "#{node[:solr][:home]}/solr.xml" do
#    source "solr.xml.erb"
#    owner "root"
#    group "root"
#    mode "0664" 
#end
#
#template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/solrconfig.xml" do
#    source "solrconfig.xml.erb"
#    owner "root"
#    group "root"
#    mode "0644"
#end
#
#template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/schema.xml" do
#    source "schema.xml.erb"
#    owner "root"
#    group "root"
#    mode "0644"
#end
