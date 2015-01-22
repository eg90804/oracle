require 'resources/generic'

module Resources
  class OraAsmVolume < Resources::Generic

    def raw_resources
      oratab = OraUtils::OraTab.new
      sids = oratab.running_asm_sids
      statement = template('puppet:///modules/oracle/ora_asm_volume/index.sql.erb', binding)
      sql_on(sids, statement)
    end

  end
end