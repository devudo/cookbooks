maintainer       "Jon Pugh"
maintainer_email "jon@thinkdrop.net"
license          "N/A PROPRIETARY & CONFIDENTIAL"
description      "Installs/Configures servers to run devudo.com"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0"

%w{ apt sudo nginx mysql openssl php php-fpm }.each do |cb|
  depends cb
end