require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'utils/oracle_access'
require 'utils/title_parser'

module Puppet
  newtype(:init_param) do
    include EasyType
    include ::Utils::OracleAccess
    extend ::Utils::TitleParser

    desc "This resource allows you to manage Oracle parameters."

    set_command(:sql)

    ensurable

    on_create do | command_builder |
      statement = "alter system set \"#{parameter_name}\" = #{self[:value]} scope=spfile"
      command_builder.add(statement)
      execute_on_sid( sid, command_builder)
    end

    on_modify do | command_builder |
      statement = "alter system set \"#{parameter_name}\" = #{self[:value]} scope=spfile"
      command_builder.add(statement)
      execute_on_sid( sid, command_builder)
    end

    on_destroy do | command_builder |
      statement = "alter system reset \"#{parameter_name}\" scope=spfile"
      command_builder.add(statement)
      execute_on_sid( sid, command_builder)
    end

    to_get_raw_resources do
      sql_on_all_sids %q{select name, display_value from v$parameter } 
    end

    map_title_to_sid(:parameter_name) { /^((.*?\/)?(.*)?)$/}

    parameter :name
    parameter :parameter_name
    parameter :sid

    property  :value

  end
end
