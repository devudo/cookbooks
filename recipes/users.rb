# DEVUDO dev users

# Users
user "jon" do
  comment "Jon Pugh"
  home "/home/jon"
  shell "/bin/bash"
  system true
end
group "sudo" do
  action :modify
  members "jon"
  append true
end 
directory "/home/jon" do
  owner "jon"
  group "jon"
  mode "0755"
  action :create
  recursive true
end 
directory "/home/jon/.ssh" do
  owner "jon"
  group "jon"
  mode "0755"
  action :create
  recursive true
end 
cookbook_file "/home/jon/.ssh/authorized_keys" do
  source "ssh/id_rsa.pub.jon"
  action :create
  backup false
  owner "jon"
  group "jon"
  mode "0600"
end
