require 'tempfile'
require 'fileutils'
require 'utils/ora_daemon'

module Utils
  module OracleAccess

    ORATAB = "/etc/oratab"

    def self.included(parent)
      parent.extend(OracleAccess)
    end



    ##
    #
    # Use this function to execute Oracle statements
    #
    # @param command [String] this is the commands to be given
    #
    #
    def sql_on_all_sids( command, parameters = {})
      username = parameters.fetch(:username) { 'sysdba'}
      password = parameters[:password] # nil is allowed
      results = []
      sids.each do |sid|
        results = results + sql(command, {:sid => sid}.merge(parameters))
      end
      results
    end


    ##
    #
    # Use this function to execute Oracle statements
    #
    # @param command [String] this is the commands to be given
    #
    #
    def sql( command, parameters = {})
      sid = parameters.fetch(:sid) { fail "SID must be present"}
      username = parameters.fetch(:username) { 'sysdba'}
      password = parameters[:password] # nil is allowed
      Puppet.info "Executing: #{command} on database #{sid}"
      csv_string = execute_sql(command, :sid => sid, :username => username, :password => password)
      add_sid_to(convert_csv_data_to_hash(csv_string, [], :converters=> lambda {|f| f ? f.strip : nil}),sid)
    end

    private

    def oratab
      values = []
      fail "/etc/oratab not found. Probably Oracle not installed" unless File.exists?(ORATAB)
      File.open(ORATAB) do | oratab|
        oratab.each_line do | line|
          content = [:sid, :home, :start].zip(line.split(':'))
          values << Hash[content] unless comment?(line)
        end
      end
      values
    end

    def execute_on_sid(sid, command_builder)
      command_builder.options.merge!(:sid => sid)
      nil
    end

    def default_sid
      oratab.first[:sid]
    end

    def sids
      oratab.collect{|i| i[:sid]}
    end

    def execute_sql(command, parameters)
      db_sid = parameters.fetch(:sid) { raise ArgumentError, "No sid specified"}
      username = parameters.fetch(:username) { 'sysdba'}
      password = parameters[:password] # null allowd
      daemon = OraDaemon.run('oracle', db_sid, username, password)
      outFile = Tempfile.new([ 'output', '.csv' ])
      outFile.close
      FileUtils.chown('oracle', nil, outFile.path)
      FileUtils.chmod(0644, outFile.path)
      if timeout_specified
        daemon.execute_sql_command(command, outFile.path, timeout_specified)
      else
        daemon.execute_sql_command(command, outFile.path)
      end
      File.read(outFile.path)
    end

    def comment?(line)
      line.start_with?('#') || line.start_with?("\n")
    end


    def add_sid_to(elements, sid)
      elements.collect{|e| e['SID'] = sid; e}
    end

    # This is a little hack to get a specified timeout value
     def timeout_specified
      if respond_to?(:to_hash)
        to_hash.fetch(:timeout) { nil} #
      else
        nil
      end
    end



  end
end