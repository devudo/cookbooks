
## Setup Drush
## This recipe requires php... if you include drush, include php first:
## include_recipe "php"

# Download and extract to node[:drush][:install_dir], only if it doesn't exist already.
execute "Install Drush" do
  command <<-EOH
wget -O - http://ftp.drupal.org/files/projects/drush-#{node[:drush][:version]}.tar.gz | sudo tar -zxf - -C #{node[:drush][:install_dir].sub('drush', '')}  
  EOH
  not_if { ::File.exists?(node[:drush][:install_dir])}
end
link "#{node[:drush][:command_path]}" do
  to "#{node[:drush][:install_dir]}/drush"
  not_if "test -L #{node[:drush][:command_path]}"
end

# Run sudo drush only once the symlink is in place.
execute "sudo drush" do
  command "drush"
  action :nothing
  subscribes :run, resources(:link => "#{node[:drush][:command_path]}"), :immediately 
end
