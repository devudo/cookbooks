#
# This file will remove existing git repos and replace with links
# to /source repos.
#
sourceList = {
  'devudo/devudo_provision' => '/var/aegir/.drush/devudo_provision',
  'drupal/provision_git' => '/var/aegir/.drush/provision_git',
  'drupal/provision_solr' => '/var/aegir/.drush/provision_solr',
  'drupal/provision_logs' => '/var/aegir/.drush/provision_logs',
  'drupal/devshop_provision' => '/var/aegir/.drush/devshop_provision'
}

sourceList.each{|source_path, original_path|
  if File.directory?(original_path)
    directory original_path do
      action :delete
      recursive true
    end
    link original_path do
      to "/source/#{source_path}"
      group "aegir"
      owner "aegir"
    end  
  end
}

