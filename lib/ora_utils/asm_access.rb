require 'tempfile'
require 'fileutils'

module OraUtils
  module AsmAccess

    OS_USER_NAME = 'ASM_OS_USER'

    def self.included(parent)
      parent.extend(AsmAccess)
    end

    ##
    #
    # Use this function to execute asmcmd statements
    #
    # @param command [String] this is the commands to be given
    #
    #
    def asmcmd( command, parameters = {})
      Puppet.debug "Executing asmcmd command: #{command}"
      os_user = parameters.fetch(:os_user) { default_asm_user}
      full_command = "export ORACLE_SID='+ASM1';export ORAENV_ASK=NO;. oraenv; asmcmd #{command}"
      options = {:uid => os_user, :failonfail => true}
      Puppet::Util::Execution.execute(full_command, options)
    end

    private

    def default_asm_user
      ENV[OS_USER_NAME] ||  Facter.value(OS_USER_NAME) || 'grid'
    end

  end
end