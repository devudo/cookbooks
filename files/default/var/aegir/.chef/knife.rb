log_level                :info
log_location             STDOUT
node_name                'jon'
client_key               '/home/jon/.chef/jon.pem'
validation_client_name   'chef-validator'
validation_key           '/home/jon/.chef/validation.pem'
chef_server_url          'http://chief.devudo.com:4000'
cache_type               'BasicFile'
cache_options( :path => '/home/jon/.chef/checksums' )
# Rackspace:
knife[:rackspace_api_key]      = "e93596076f1a3bd404d6a8b790b8a96b"
knife[:rackspace_api_username] = "careernerd"
knife[:rackspace_version] = 'v2'

