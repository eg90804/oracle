require 'ora_utils/ora_command'
require 'easy_type'

module OraUtils
  class SqlplusCommand < OraUtils::OraCommand
    include EasyType::Template

    VALID_OPTIONS = [
      :sid,
      :os_user,
      :password,
      :timeout,
      :username,
      :daemonized
    ]

    attr_reader :daemonized

    def initialize(options = {})
      super('sqlplus -S /nolog ', options, VALID_OPTIONS)
      @daemonized = options.fetch(:daemonized) { false}
    end

    def execute(arguments)
      options = {:failonfail => true}
      value = ''
      command = command_string(arguments)
      within_time(@timeout) do
        Puppet.debug "Executing #{@command} command: #{arguments} on #{@sid} as #{os_user}, connected as #{username}"
        value = Puppet::Util::Execution.execute(command, options)
      end
      value
    end


    def execute_sql_command(command, output_file)
      Puppet.debug "Executing sql statement :\n #{command}"
      script = command_file( template('puppet:///modules/oracle/shared/execute.sql.erb', binding))
      execute "@#{script}"
      File.read(output_file)
    end

    private

    def command_file( content)
      command_file = Tempfile.new([ 'command', '.sql' ])
      ObjectSpace.undefine_finalizer(command_file)  # Don't delete the file
      command_file.write(content)
      command_file.close
      FileUtils.chown(@os_user, nil, command_file.path)
      FileUtils.chmod(0644, command_file.path)
      FileUtils.chown(@os_user, nil, command_file.path)
      FileUtils.chmod(0644, command_file.path)
      command_file.path
    end

  end
end

