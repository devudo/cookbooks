
# Stolen from mysql cookbook
# https://github.com/opscode-cookbooks/mysql/blob/master/recipes/server.rb
if Chef::Config[:solo]
  missing_attrs = %w{
    server_debian_password server_root_password server_repl_password
  }.select do |attr|
    node["mysql"][attr].nil?
  end.map { |attr| "node['mysql']['#{attr}']" }

  if !missing_attrs.empty?
    Chef::Application.fatal!([
        "You must set #{missing_attrs.join(', ')} in chef-solo mode.",
        "For more information, see https://github.com/opscode-cookbooks/mysql#chef-solo-note"
      ].join(' '))
  end
else
  # generate all passwords
  node.set_unless['mysql']['server_debian_password'] = secure_password
  node.set_unless['mysql']['server_root_password']   = secure_password
  node.set_unless['mysql']['server_repl_password']   = secure_password
  node.save
end

execute "Secure MySQL Installation" do
  command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" < \"/etc/mysql/secure_installation.sql\""
  action :nothing
end

cookbook_file "/etc/mysql/secure_installation.sql" do
  source "secure_installation.sql"
  notifies :run, resources(:execute => "Secure MySQL Installation"), :immediately
  not_if {File.exists?("/etc/mysql/secure_installation.sql")}
end
