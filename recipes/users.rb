# DEVUDO dev users
#userlist = ['jon', 'jacinto', 'kory']
userlist = node[:devudo][:users]

group "devs" do
  action :create
  group_name "devs"
end

# Dev Users
userlist.each{|username, ssh_key|
  user "#{username}" do
    home "/home/#{username}"
    shell "/bin/bash"
    system true
  end
  group "sudo" do
    action :modify
    members "#{username}"
    append true
  end
  group "devs" do
    action :modify
    members "#{username}"
    append true
  end 
  directory "/home/#{username}" do
    owner "#{username}"
    group "#{username}"
    mode "0755"
    action :create
    recursive true
  end 
  directory "/home/#{username}/.ssh" do
    owner "#{username}"
    group "#{username}"
    mode "0755"
    action :create
    recursive true
  end
  file "/home/#{username}/.ssh/authorized_keys" do
    content ssh_key
    action :create
    backup false
    owner username
    group username
    mode "0600"
  end
}

# grant devudo user ability to run "sudo chef-client"
cookbook_file "/etc/sudoers.d/devudo" do
  source "sudoers.d/devudo"
  action :create
  backup false
  owner "root"
  group "root"
  mode 00440
end