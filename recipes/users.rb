# DEVUDO dev users
userlist = ['jon', 'jacinto', 'kory']

# Users
userlist.each{|username|
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
  cookbook_file "/home/#{username}/.ssh/authorized_keys" do
    source "ssh/id_rsa.pub.#{username}"
    action :create
    backup false
    owner "#{username}"
    group "#{username}"
    mode "0600"
  end
  
  # Aegir user access
  cookbook_file "/home/#{username}/.ssh/authorized_keys" do
    source "ssh/id_rsa.pub.#{username}"
    action :create
    backup false
    owner "#{username}"
    group "#{username}"
    mode "0600"
  end
}
