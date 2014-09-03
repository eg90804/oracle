require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'utils/oracle_access'
require 'utils/title_parser'


module Puppet
  newtype(:tablespace) do
    include EasyType
    include ::Utils::OracleAccess
    extend ::Utils::TitleParser

    desc "This resource allows you to manage an Oracle tablespace."

    set_command(:sql)

    ensurable

    to_get_raw_resources do
      sql_on_all_sids(template('puppet:///modules/oracle/tablespace_index.sql', binding))
    end

    on_create do | command_builder |
      base_command = "create #{ts_type} tablespace \"#{tablespace_name}\""
      base_command << " segment space management #{segment_space_management}" if segment_space_management
      base_command
      command_builder.add(base_command, :sid => sid)
    end

    on_modify do | command_builder |
      command_builder.add("alter tablespace \"#{tablespace_name}\"", :sid => sid)
    end

    on_destroy do | command_builder |
      command_builder.add("drop tablespace \"#{tablespace_name}\" including contents and datafiles", :sid => sid)
    end

    map_title_to_sid(:tablespace_name) { /^((.*?\/)?(.*)?)$/}

    parameter :name
    parameter :tablespace_name
    parameter :sid

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
