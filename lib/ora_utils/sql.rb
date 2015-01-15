require 'tempfile'
require 'fileutils'
require 'ora_utils/ora_daemon'
require 'ora_utils/ora_direct'
require 'ora_utils/ora_tab'
require 'ora_utils/sqlplus_command'

module OraUtils
  class Sql

    attr_reader :sid, :username, :password, :os_user, :timeout, :daemonized

    def initialize(options = {})
      @command     = SqlplusCommand.new( options)
      @sid         = @command.sid
      @os_user     = @command.os_user
      @username    = @command.username
      @password    = @command.password
      @timeout     = @command.timeout
      @daemonized  = @command.daemonized
      if @daemonized
        @executor  = OraDaemon.run(@os_user, @sid, @username, @password)
      else
        @executor  = OraDirect.run(@os_user, @sid, @username, @password)
      end
    end

    def execute(command)
      create_output_file
      if @timeout
        @executor.execute_sql_command(command, @output_file.path, timeout)
      else
        @executor.execute_sql_command(command, @output_file.path)
      end
    end

    private

    def create_output_file
      @output_file = Tempfile.new([ 'output', '.csv' ])
      @output_file.close
      FileUtils.chown(@os_user, nil, @output_file.path)
      FileUtils.chmod(0644, @output_file.path)
      @output_file.close
      FileUtils.chown(@os_user, nil, @output_file.path)
      FileUtils.chmod(0644, @output_file.path)
    end

  end
end