maintainer       "Jon Pugh"
maintainer_email "jon@thinkdrop.net"
license          "N/A PROPRIETARY & CONFIDENTIAL"
description      "Installs/Configures servers to run devudo.com"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1"

%w{ drush apt sudo newrelic nginx mysql openssl php php-fpm runit ssh_known_hosts github-deploys}.each do |cb|
  depends cb
end