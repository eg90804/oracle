require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'utils/oracle_access'

module Puppet
  newtype(:tablespace) do
    include EasyType
    include ::Utils::OracleAccess

    desc "This resource allows you to manage an Oracle tablespace."

    set_command(:sql)

    ensurable

    on_create do | command_builder |
      base_command = "create #{ts_type} tablespace \"#{name}\""
      base_command << " segment space management #{segment_space_management}" if segment_space_management
      base_command
    end

    on_modify do | command_builder |
      "alter tablespace \"#{name}\""
    end

    on_destroy do | command_builder |
      "drop tablespace \"#{name}\" including contents and datafiles"
    end

    to_get_raw_resources do
      sql(template('puppet:///modules/oracle/tablespace_index.sql', binding))
    end

    parameter :name
    parameter :timeout
    property  :bigfile
    property  :datafile
    property  :size
    group(:autoextend_group) do
      property  :autoextend
      property  :next
      property  :max_size
    end
    property  :extent_management
    property  :segment_space_management
    property  :logging


    def ts_type
      if self['bigfile'] == :yes
        'bigfile'
      else
        'smallfile'
      end
    end


  end
end
