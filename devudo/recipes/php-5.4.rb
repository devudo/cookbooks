
# I tried to do this "the right way"...
# but obviously I was doing something wrong...

#apt_repository "php54" do
#  uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
#  distribution node['lsb']['codename']
#  components ["main"]
#  keyserver "keyserver.ubuntu.com"
#  key "E5267A6C"
#end

# Gotta have apt.
include_recipe "apt"

# Get the command add-apt-repository
package "python-software-properties"

# Add the PPA and then run execute[apt-get update]
# @see apt:default recipe.
execute "add ppa with bash" do
  command "add-apt-repository ppa:ondrej/php5 -y"
  notifies :run, "execute[apt-get update]", :immediately
  not_if {File.exists?("/etc/apt/sources.list.d/ondrej-php5-precise.list")}
end


include_recipe "php"