require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'ora_utils/oracle_access'
require 'ora_utils/title_parser'

module Puppet
  newtype(:init_param) do
    include EasyType
    include ::OraUtils::OracleAccess
    extend ::OraUtils::TitleParser

    desc "This resource allows you to manage Oracle parameters."

    set_command(:sql)

    ensurable

    on_create do | command_builder |
      statement = "alter system set \"#{parameter_name}\" = #{self[:value]} scope=spfile"
      command_builder.add(statement, :sid => sid)
    end

    on_modify do | command_builder |
      statement = "alter system set \"#{parameter_name}\" = #{self[:value]} scope=spfile"
      command_builder.add(statement, :sid => sid)
    end

    on_destroy do | command_builder |
      statement = "alter system reset \"#{parameter_name}\" scope=spfile"
      command_builder.add(statement, :sid => sid)
    end

    to_get_raw_resources do
      sql_on_all_sids %q{select #{columns} from #{parameter_view} } 
    end

    map_title_to_sid(:parameter_name) { /^((.*?\/)?(.*)?)$/}

    parameter :name
    parameter :parameter_name
    parameter :sid

    property  :value
    parameter :for_instance

    private

    def columns
      instance_specfified? ? 'name, display_value, inst_id' : 'name, display_value'
    end

    def parameter_view
      instance_specfified? ? 'GV$PARAMETER' : 'V$PARAMETER'
    end

    def instance_specfified?
      self[:for_instance] 
    end
  end
end
