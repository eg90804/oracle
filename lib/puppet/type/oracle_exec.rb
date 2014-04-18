require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'utils/oracle_access'

module Puppet
  #
  # Create a new type oracle_user. Oracle user, works in conjunction 
  # with the SqlResource
  #
  newtype(:oracle_exec) do
    include EasyType
    include ::Utils::OracleAccess

    desc "This resource allows you to execute any sql command in a database"

    set_command(:sql)

    to_get_raw_resources do
      []
    end

    on_create do
      self[:command]
    end

    on_modify do
      fail "It shouldn't be possible to modify an oracle_exec"
    end

    on_destroy do
      fail "It shouldn't be possible to destroy an oracle_exec"
    end

    property :command

  end
end


