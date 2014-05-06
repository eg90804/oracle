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

    ensurable

    set_command(:sql)

    to_get_raw_resources do
      []
    end

    on_create do | command_builder |
      output = sql self[:command]
      send_log(:info, output) if self[:logoutput] == :true
      '' # return empty string because we already did our stuff
    end

    on_modify do | command_builder |
      fail "It shouldn't be possible to modify an oracle_exec"
    end

    on_destroy do | command_builder |
      fail "It shouldn't be possible to destroy an oracle_exec"
    end

    property  :command
    parameter :logoutput

  end
end


