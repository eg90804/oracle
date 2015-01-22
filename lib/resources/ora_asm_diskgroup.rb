require 'resources/generic'

module Resources
  class OraAsmDiskgroup < Resources::Generic

    def raw_resources
      sids = @oratab.running_asm_sids
      statement = template('puppet:///modules/oracle/ora_asm_diskgroup/index.sql.erb', binding)
      sql_on(sids, statement)
    end

  end
end