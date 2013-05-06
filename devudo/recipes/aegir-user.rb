
# Create the Aegir user
user "aegir" do
  comment "Aegir Hosting Management"
  home "/var/aegir"
  shell "/bin/bash"
  system true
end
# Add aegir to www-data group
group "www-data" do
  action :modify
  members "aegir"
  append true
end
directory "/var/aegir" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end
directory "/var/aegir/.drush" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end
directory "/var/aegir/.ssh" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end
directory "/var/aegir/config" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end

# Setup its ssh keys
path_to_key = "#{node[:aegir][:dir]}/.ssh/id_rsa"

Chef::Log.debug("Generating ssh keys for aegir user")
execute "aegir-ssh-keys" do
  user "aegir"
  creates "#{path_to_key}.pub"
  command "ssh-keygen -t rsa -q -f #{path_to_key} -P \"\""
  not_if {
    File.exists?(path_to_key)
  }
end
Chef::Log.debug("[SSH] Key generation complete")

# Add aegir's public key to our repos
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


#cookbook_file "/var/aegir/.ssh/id_rsa" do
#  source "ssh/aegir/id_rsa"
#  action :create
#  backup false
#  owner "aegir"
#  group "aegir"
#  mode "0600"
#end
#cookbook_file "/var/aegir/.ssh/id_rsa.pub" do
#  source "ssh/aegir/id_rsa.pub"
#  action :create
#  backup false
#  owner "aegir"
#  group "aegir"
#  mode "0600"
#end
cookbook_file "/var/aegir/.ssh/config" do
  source "ssh/aegir/config"
  action :create
  backup false
  owner "aegir"
  group "aegir"
  mode "0600"
end

# Here we take the attribute and save the authorized_keys file.
# Right now this is handled in shop_hosting so the web app
# can control who is authorized.
file "/var/aegir/.ssh/authorized_keys" do
  content node[:aegir][:authorized_keys]
  action :create
  backup false
  owner "aegir"
  group "aegir"
  mode "0600"
end

# prepare drush commands folder
directory "/usr/share/drush/commands" do
  owner "aegir"
  group "aegir"
  mode 00755
  action :create
  recursive true
end

# @TODO: Utilize sudo cookbook
# Make sure the Aegir user is allowed to restart apache
package 'sudo' do
  action :install
end
cookbook_file "/etc/sudoers.d/aegir" do
  source "sudoers.d/aegir"
  action :create
  backup false
  owner "root"
  group "root"
  mode 00440
end