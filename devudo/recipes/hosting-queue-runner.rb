
include_recipe "apt"
include_recipe "drush"



#
#
#
## add the commandfile
#directory "/etc/service/hosting-queue" do
#  owner "root"
#  group "root"
#  action :create
#  recursive true
#end
#
#
## add the commandfile
##file "#{node['aegir']['hosting_queue_runner_path']}/runit" do
#file "/etc/service/hosting-queue/runit" do
#  owner "aegir"
#  group "aegir"
#  mode "0700"
#  action :create
#  content '#!/bin/bash
#/usr/share/drush/drush @hostmaster hosting-queue-runner'
#end


#include_recipe "runit"
#
#runit_service "hosting-queue"
#
#include_recipe "supervisor"


#template "#{node['supervisor']['dir']}/hosting_queue_runner.conf" do
#  source "hosting_queue_runner.conf.erb"
#  not_if {File.exists?("#{node['supervisor']['dir']}/hosting_queue_runner.conf")}
#end

#
## Common hosting tools
#git "#{node[:aegir][:dir]}/hostmaster-#{node[:aegir][:version]}/sites/all/modules/hosting_queue_runner" do
#    repository "http://git.drupal.org/project/hosting_queue_runner.git"
#    reference "6.x-1.x"
#    action :sync
#    user "aegir"
#end
#
#service "hosting-queue-runner" do
#  supports :restart => true, :start => true, :stop => true
#  restart_command "/etc/init.d/hosting-queue-runner restart"
#  action :nothing
#end
#
#bash "hosting-queue-runner-install" do
#  user "root"
#  code "/usr/sbin/update-rc.d hosting-queue-runner defaults"
#  action :nothing
#  #code "echo 'HIHIHIHIHIHIHIHIHI'"
#end
#
#template "hosting-queue-runner" do
#  path "/etc/init.d/hosting-queue-runner"
#  source "init.d/hosting-queue-runner.erb"
#  owner "root"
#  group "root"
#  mode "0644"
#  notifies :run, "bash[hosting-queue-runner-install]", :immediately
#  #notifies :enable, "service[hosting-queue-runner]"
#  #notifies :start, "service[hosting-queue-runner]"
#end
