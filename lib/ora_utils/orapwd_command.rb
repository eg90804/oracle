require 'ora_utils/ora_command'

module OraUtils
  class OraPwdCommand < OraCommand

    def initialize(options = {})
      super(:orapwd, options)
    end

  end
end

