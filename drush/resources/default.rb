actions :run
attribute :user, :default => 'aegir'
attribute :group, :default => 'aegir'
attribute :command, :name_attribute => true
attribute :cwd, :default => '/var/aegir'

def initialize(*args)
  super
  @action = :run
end