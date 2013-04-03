
# Get hosting_queue_runner
include_recipe "runit"
runit_service "hosting-queue"

# @TODO: Enable hosting_queue-runner in devmaster.profile
drush "@hostmaster en hosting_queue_runner" 
