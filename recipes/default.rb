#
# Cookbook Name:: devudo-cookbooks
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# this is the simple way to get started.
# We let apt handle installing aegir... for now

apt_repository "koumbit-stable" do
  uri "http://debian.koumbit.net/debian"
  components ["stable", "main"]
  key "http://debian.koumbit.net/debian/key.asc"
  action :add
end

require_recipe "apt"
require_recipe "sudo"
package "aegir"


