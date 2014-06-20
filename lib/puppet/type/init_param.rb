require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'utils/oracle_access'

module Puppet
  newtype(:init_param) do
    include EasyType
    include ::Utils::OracleAccess

    desc "This resource allows you to manage Oracle parameters."

    set_command(:sql)

    ensurable

    on_create do | command_builder |
      "alter system set \"#{name}\" = #{self[:value]} scope=#{param_scope}"
    end

    on_modify do | command_builder |
      "alter system set \"#{name}\" = #{self[:value]} scope=#{param_scope}"
    end

    on_destroy do | command_builder |
      "alter system reset \"#{name}\" scope=#{param_scope}"
    end

    to_get_raw_resources do
      sql %q{select name, display_value, case issys_modifiable when 'FALSE' then 'NO' else 'YES' end MOD from v$parameter } 
    end

    parameter :name
    property  :value
    property  :ismodifiable

    def param_scope
      if self['ismodifiable'] == :yes
        'both'
      else
        'spfile'
      end
    end

  end
end
