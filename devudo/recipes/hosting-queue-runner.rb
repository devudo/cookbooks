

# Get provision.
drush "@hostmaster dl hosting_queue_runner" do
  not_if do
    File.exists?("#{node[:aegir][:dir]}/#{node[:aegir][:profile]}-#{node[:aegir][:version]}/sites/all/modules/hosting_queue_runner")
  end
end

# @TODO: Enable hosting_queue-runner in @hostmaster
include_recipe "runit"
runit_service "hosting-queue"

