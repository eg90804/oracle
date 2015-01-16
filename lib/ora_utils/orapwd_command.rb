require 'ora_utils/ora_command'

module OraUtils
  class OrapwdCommand < OraCommand

    def initialize(options = {})
      super(:orapwd, options)
    end

  end
end

