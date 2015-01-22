require 'ora_utils/commands'
require 'ora_utils/ora_tab'

module Puppet::Parser::Functions

  newfunction(:physical_device_for_asm_volume, :type => :rvalue) do |args|

    self.extend(::OraUtils::Commands)
    
    diskgroup_name  = args[0]
    volume_name     = args[1]
    sid             = args[3] || default_asm_sid

    info = asmcmd("volinfo -G #{diskgroup_name} #{volume_name}", :sid => sid)
    match = info.scan(/Volume Device: (.*)\n/)
    match && match.flatten.first
  end

  private

  # Retrieve the default sid on this system
  def default_asm_sid
    oratab = OraUtils::OraTab.new
    oratab.default_asm_sid
  rescue
    ''
  end

end



