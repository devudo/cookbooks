#
# Cookbook Name:: github_deploys
# Recipe:: default
#
# Copyright 2013, Duedil Limited
#
deploy_user = "#{node[:github_deploys][:deploy_user]}"

user "#{deploy_user}" do
  comment "Github Deploy user"
  shell "/bin/bash"
  home "#{node[:github_deploys][:deploy_home_path]}/#{deploy_user}"
  gid node[:github_deploys][:deploy_group]
  supports :manage_home => true
  uid	node[:github_deploys][:deploy_uid]
end

path_to_key = "#{node[:github_deploys][:deploy_home_path]}/#{node[:github_deploys][:deploy_user]}/.ssh/id_rsa"


Chef::Log.debug("generate ssh skys for #{deploy_user} user")
execute "generate ssh keys for #{deploy_user}" do
  user "#{deploy_user}"
  creates "#{path_to_key}.pub"
  command "ssh-keygen -t rsa -q -f #{path_to_key} -P \"\""
end
Chef::Log.debug("[SSH] Key generation complete")

ruby_block "upload_key_to_github" do
	block do

		class Chef::Resource::RubyBlock
		  include GithubAPI
		end

		upload_key(
			node[:github_deploys][:github_api][:email],
			node[:github_deploys][:github_api][:password],
			node[:fqdn],
			"#{path_to_key}.pub")
	end
end
