require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'ora_utils/oracle_access'
require 'ora_utils/ora_tab'
require 'ora_utils/directories'


module Puppet
  newtype(:ora_database) do
    include EasyType
    include ::OraUtils::OracleAccess
    include ::OraUtils::Directories

    SCRIPTS = [
      "CreateDBCatalog.sql",
      "JServer.sql",
      "Context.sql",
      "Xdb_protocol.sql",
      "Cwmlite.sql",
      "CreateClustDBViews.sql",
      "Grants.sql",
      "LockAccount.sql",
      "Psu.sql"]

    desc "This resource allows you to manage an Oracle Database."

    set_command([:sql, :remove_directories])

    ensurable

    on_create do | command_builder |
      begin
        create_directories
        create_init_ora_file
        add_oratab_entry
        create_ora_scripts(SCRIPTS)
        statement = template('puppet:///modules/oracle/ora_database/create.sql.erb', binding)
        command_builder.add(statement, :sid => name, :daemonized => false)
        if create_catalog?
          SCRIPTS.each do |script| 
            command_builder.after("@#{oracle_base}/admin/#{name}/scripts/#{script}", :sid => name, :daemonized => false)
          end
        end
        nil
      rescue
        remove_directories
        fail "Error creating database #{name}"
        nil
      end
    end

    on_modify do | command_builder |
      info "database modification not yet implemented"
    end

    on_destroy do | command_builder |
      statement = template('puppet:///modules/oracle/ora_database/destroy.sql.erb', binding)
      command_builder.add(statement, :sid => name, :daemonized => false)
      command_builder.after('', :remove_directories)
    end

    parameter :name
    parameter :system_password
    parameter :sys_password
    parameter :init_ora_content
    parameter :timeout
    parameter :control_file
    property  :maxdatafiles
    property  :maxinstances
    property  :character_set
    property  :national_character_set
    property  :tablespace_type
    property  :logfile
    property  :logfile_groups
    property  :maxlogfiles
    property  :maxlogmembers
    property  :maxloghistory
    property  :archivelog
    property  :force_logging
    property  :extent_management
    property  :datafiles
    property  :sysaux_datafiles
    group(:default_tablespace_group) do
      property  :default_tablespace_type
      property  :default_tablespace_name
      property  :default_tablespace_datafiles
      property  :default_tablespace_extent_management
    end
    group(:default_temporary_tablespace_group) do
      property  :default_temporary_tablespace_type
      property  :default_temporary_tablespace_name
      property  :default_temporary_tablespace_datafiles
      property  :default_temporary_tablespace_extent_management
    end
    group(:undo_tablespace_group) do
      property  :undo_tablespace_type
      property  :undo_tablespace_name
      property  :undo_tablespace_datafiles
    end
		parameter :oracle_home
		parameter :oracle_base
		parameter :oracle_user
		parameter :install_group
		parameter :autostart
    parameter :create_catalog
    # -- end of attributes -- Leave this comment if you want to use the scaffolder

    private

    def create_init_ora_file
      File.open(init_ora_path, 'w') { |f| f.write(init_ora_content) }
      ownened_by_oracle( init_ora_path)
      Puppet.debug "File #{init_ora_path} created with specified init.ora content"
    end

    def add_oratab_entry
      oratab = OraUtils::OraTab.new
      oratab.ensure_entry(name, oracle_home, autostart)
    end

    def create_ora_scripts( scripts)
      scripts.each {|s| create_ora_script(s)}
    end

    def create_ora_script( script)
      Puppet.info "creating script #{script}"
      content = template("puppet:///modules/oracle/ora_database/#{script}.erb", binding)
      path = "#{oracle_base}/admin/#{name}/scripts/#{script}"
      File.open(path, 'w') { |f| f.write(content) }
      ownened_by_oracle(path)
    end

    def init_ora_path
      "#{oracle_home}/dbs/init#{name}.ora"
    end


  end
end
