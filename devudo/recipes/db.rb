
include_recipe "apt"


# Get the command add-apt-repository
package "python-software-properties"

execute "add mariadb ppa with bash" do
  command "apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db"
  notifies :run, "execute[apt-get update]", :immediately
end

execute "add mariadb ppa with bash" do
  command "add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu precise main' -y"
  notifies :run, "execute[apt-get update]", :immediately
end


node.set['mysql']['client']['packages'] =  %w{mariadb-client}
node.set['mysql']['server']['packages'] =  %w{mariadb-server}
node.set['mysql']['use_upstart'] = true
#
#node.set['mysql']['client']['packages'] =  %w{libmariadbclient-dev libmariadbclient18 libmariadbd-dev libmysqlclient18 mariadb-client mariadb-client-5.5 mariadb-client-core-5.5 mariadb-common }
#
#node.set['mysql']['server']['packages'] =  %w{mariadb-server mariadb-server-5.5 mariadb-server-core-5.5 mariadb-test mariadb-test-5.5 mysql-common}

include_recipe "mysql::server"
#include_recipe "devudo::mysql_secure_installation"
