require 'ora_utils/oracle_access'
require 'easy_type'
require 'puppet/type/ora_schema_definition/version'

Puppet::Type.type(:ora_schema_definition).provide(:sqlplus) do
  include EasyType::Provider
  include EasyType::Template
  include EasyType::Helpers
  include ::OraUtils::OracleAccess

  desc "Manage The schema definition"

  mk_resource_methods

  def self.prefetch(resources)
    resources.each do |name, resource|
      options = options_for(resource[:schema_name], resource[:password], sid_from(resource))
      destroy(resource) if resource[:reinstall] == :true
      if version_table_exists?(options)
        statement = template('puppet:///modules/oracle/ora_schema_definition/index.sql.erb', binding)
        versions = sql(statement, options)
      else
        versions = []
      end
      if versions.empty?
        resource.provider = new(:ensure => :absent)
      else
        resource.provider = map_raw_to_resource(versions.last)
      end
    end
  end

  def self.version_table_exists?(options)
    statement = template('puppet:///modules/oracle/ora_schema_definition/version_table_exists.sql.erb', binding)
    rows = sql(statement, options)
    !rows.empty?
  end

  def self.options_for(username, password, sid)
    options = {:sid => sid}
    options.merge!( :username => username)
    password = password.nil? ? username : password
    options.merge!( :password => password)
    options
  end

  def upgrade_to(version)
    check_upgrade_path
    ensure_version_table
    scripts = scripts_for_upgrade(self.ensure, version)
    execute_scripts(scripts) do |script|
      sequence, application, version, description = parse_script_name(script)
      "insert into schema_version (id, application, version, description, installation_time) values ('#{sequence}', '#{application}', '#{version}', '#{description}', sysdate)"
    end
  end

  def downgrade_to(version)
    check_downgrade_path
    ensure_version_table
    scripts = scripts_for_downgrade(self.ensure, version)
    execute_scripts(scripts) do | script|
      sequence, _, _, _ = parse_script_name(script)
      "delete from schema_version where lpad(id,4,'0')='<%= sequence -%>'"
    end
  end

  def self.destroy(resource)
    Puppet.info 'deleting all schema information'
    options = options_for(resource[:schema_name], resource[:password], sid_from(resource))
    options[:parse] = false
    statement = template('puppet:///modules/oracle/ora_schema_definition/drop.sql.erb', binding)
    sql(statement, options)
  end

  private 

  def execute_scripts( scripts)
    statements = template('puppet:///modules/oracle/ora_schema_definition/execute.sql.erb', binding)
    scripts.each do |script|
      statements << "REM\n"
      Puppet.info "Applying #{script}"
      statements << "REM Including file #{script}\n"
      statements << "REM\n"
      statements << File.read(script)
      statements << "\n"
      statements << "commit;\n"
      statements << "connect #{resource[:schema_name]}/#{resource[:password]}\n"
      statements << yield(script) << ";\n"
      statements << "commit;\n"
    end
    options = self.class.options_for(resource[:schema_name], resource[:password], sid_from(resource))
    sql statements, options
  end

  def scripts_for_upgrade(from, to)
    upgrade_scripts.select {|s| required_for_upgrade?(s, from, to)}.sort!
  end

  def scripts_for_downgrade(from, to)
    downgrade_scripts.select {|s| required_for_downgrade?(s, from, to)}.sort!.reverse!
  end

  def required_for_upgrade?(script_name, from, to)
    required_for?(script_name,from, to) { |version, from, to| version > from && version <= to}
  end

  def required_for_downgrade?(script_name, from, to)
    required_for?(script_name,from, to) { |version, from, to| version <= from && version > to}
  end

  def required_for?(script_name, from, to)
    _, _, version = parse_script_name(script_name)
    yield(Version.new(version), from, to)
  end

  def parse_script_name(name)
    name.basename.to_s.scan(/^(\d{4})_(\D*)_(\d+.\d+.\d+)_(.*)\.sql$/).flatten
  end

  def upgrade_scripts
    Pathname.glob("#{resource[:source_path]}/upgrades/*.sql").sort
  end

  def downgrade_scripts
    Pathname.glob("#{resource[:source_path]}/downgrades/*.sql").sort
  end

  def ensure_version_table
    options = self.class.options_for(resource[:schema_name], resource[:password], sid_from(resource))
    create_version_table(options) unless self.class.version_table_exists?(options)
  end

  def create_version_table(options)
    Puppet.info "Creating schema_versions table."
    options[:parse] = false
    statement = template('puppet:///modules/oracle/ora_schema_definition/create_table_schema_version.sql.erb', binding)
    sql(statement, options)
  end

  def check_upgrade_path
    fail "source_path #{resource[:source_path]} doesn't contain a upgrades folder" unless File.exists?("#{resource[:source_path]}/upgrades")
  end

  def check_downgrade_path
    fail "source_path #{resource[:source_path]} doesn't contain a downgrades folder" unless File.exists?("#{resource[:source_path]}/downgrades")
  end

end
