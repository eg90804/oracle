require 'ora_utils/oracle_access'
require 'easy_type/helpers'

Puppet::Type.type(:oracle_exec).provide(:sqlplus) do
  include OraUtils::OracleAccess
  include EasyType::Helpers
  include EasyType::Template

  mk_resource_methods

  def flush
    statement = resource.to_hash[:statement]
    if is_script?(statement)
      script_name = statement.sub('@','')
      statement = template(script_name, binding)
    end
    output = sql statement, :username => resource.username, :password => resource.password, :sid => resource.sid
    Puppet.info(output) if resource.logoutput == :true
  end

  private

  def is_script?(statement)
    statement[0] == 64
  end

end
