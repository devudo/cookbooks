
action :run do
  log "RUNNING: drush #{new_resource.name}"
  execute "drush command" do
    command "drush #{new_resource.name} -y"
    user new_resource.user
    group new_resource.user
    environment ({'HOME' => new_resource.cwd})
    cwd new_resource.cwd
  end
end