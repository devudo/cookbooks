
# From http://community.aegirproject.org/installing/manual

# Aegir needs lamp
include_recipe "devudo::users"
include_recipe "devudo::lamp"
include_recipe "devudo::aegir-user"


# symlink apache config
link "/etc/apache2/conf.d/aegir.conf" do
  to "/var/aegir/config/apache.conf"
end

# Get provision.
git "/var/aegir/.drush/provision" do
  repository "http://git.drupal.org/project/provision.git"
  reference "6.x-1.9"
  action :export
  user "aegir"
  group "aegir"
end

# Devudo Provision
git "/var/aegir/.drush/devudo_provision" do
    repository "git@github.com:devudo/devudo_provision.git"
    action :sync
    user "aegir"
end

# @TODO Make this its own recipe with just enough attributes for us.
bash "Start the Aegir install process" do
  not_if do
    File.exists?("#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}")
  end
  user "aegir"
  group "aegir"
  environment ({'HOME' => "#{node[:aegir][:dir]}"})
  cwd "#{node[:aegir][:dir]}"
  code <<-EOH
  drush #{node[:aegir][:profile]}-install #{node[:aegir][:frontend]} \
  --site="#{node[:aegir][:frontend]}" \
  --aegir_host="#{node[:aegir][:fqdn]}" \
  --http_service_type="apache" \
  --aegir_db_user="root" \
  --aegir_db_pass="#{node[:mysql][:server_root_password]}" \
  --db_service_type="mysql" \
  --db_port=3306 \
  --aegir_db_host="#{node[:aegir][:db_host]}" \
  --client_email="#{node[:aegir][:client_email]}" \
  --version="#{node[:aegir][:version]}" \
  --script_user="aegir" \
  --web_group="www-data" \
  --profile="#{node[:aegir][:profile]}" \
  --makefile="#{node[:aegir][:makefile]}" \
  --working-copy \
  --yes
  EOH
end

execute "Aegir: Save SSH key to a variable" do
  user "aegir"
  group "aegir"
  command 'drush @hostmaster vset devshop_public_key "$(cat ~/.ssh/id_rsa.pub)" --yes'
  environment ({'HOME' => "/var/aegir"})
  cwd "/var/aegir"
end

execute "Aegir: verify hostmaster" do
  user "aegir"
  group "aegir"
  command 'drush @hostmaster provision-verify --yes'
  environment ({'HOME' => "/var/aegir"})
  cwd "/var/aegir"
end