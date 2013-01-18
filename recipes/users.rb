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
