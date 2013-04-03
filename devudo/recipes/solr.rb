#
# Jacked from http://community.opscode.com/cookbooks/tomcat-solr
#
%w{ tomcat6 tomcat6-admin tomcat6-common tomcat6-user }.each do |package_name|
  package package_name
end

cookbook_file "/var/lib/tomcat6/webapps/solr.war" do
    source "solr.war"
    owner "root"
    group "root"
    mode "0644"
end

group "aegir" do
  action :modify
  members "tomcat6"
  append true
end
group "tomcat6" do
  action :modify
  members "aegir"
  append true
end


# Symlink to aegir config
devmaster_root = "#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}"

# Aegir Solr
git "#{node[:aegir][:dir]}/.drush/provision_solr" do
  repository "http://git.drupal.org/project/provision_solr.git"
  reference "6.x-1.x"
  action :sync
  user "aegir"
  group "aegir"
end
git "#{devmaster_root}/sites/all/modules/contrib/hosting_solr" do
  repository "http://git.drupal.org/project/hosting_solr.git"
  reference "6.x-1.x"
  action :sync
  user "aegir"
  group "aegir"
end

drush "@hostmaster en hosting_solr"
  
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
