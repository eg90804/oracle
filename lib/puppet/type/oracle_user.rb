require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'utils/oracle_access'
require 'utils/title_parser'


module Puppet
  #
  # Create a new type oracle_user. Oracle user, works in conjunction 
  # with the SqlResource provider
  #
  newtype(:oracle_user) do
    include EasyType
    include ::Utils::OracleAccess
    extend ::Utils::TitleParser

    desc %q{
      This resource allows you to manage a user in an Oracle database.
    }

    ensurable

    set_command(:sql)

    to_get_raw_resources do
      sql_on_all_sids "select * from dba_users"
    end

    on_create do | command_builder |
      statement = password ?  "create user #{username} identified by #{password}" : "create user #{username}"
      command_builder.add(statement)
      execute_on_sid( sid, command_builder)
    end

    on_modify do | command_builder |
      command_builder.add("alter user #{username}")
      execute_on_sid( sid, command_builder)
    end

    on_destroy do | command_builder |
      command_builder.add("drop user #{username}")
      execute_on_sid( sid, command_builder)
    end

    map_title_to_sid(:username) { /^((.*\/)?(.*)?)$/}

    parameter :name
    parameter :username
    parameter :sid

    property  :user_id
    property  :password
    property  :default_tablespace
    property  :temporary_tablespace
    property  :quotas
    property  :grants

  end
end
