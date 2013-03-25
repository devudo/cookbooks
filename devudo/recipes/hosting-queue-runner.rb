

# Get hosting_queue_runner (if its not there yet.)
if File.exists?("#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}/sites/all/modules/hosting_queue_runner")
    
  drush "@hostmaster dl hosting_queue_runner" 
  
  # @TODO: Enable hosting_queue-runner in @hostmaster
  include_recipe "runit"
  runit_service "hosting-queue"
  
  drush "@hostmaster en hosting_queue_runner" 
end
