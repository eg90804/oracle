require 'utils/oracle_access'
require 'easy_type/helpers'

Puppet::Type.type(:oracle_exec).provide(:sqlplus) do
  include Utils::OracleAccess
  include EasyType::Helpers
  include Puppet::Util::Logging

  mk_resource_methods

  def flush
  	if is_script?(statement)
  		sql_statements = template(statement, binding)
	    output = sql sql_statements, :username => resource.username, :password => resource.password, :sid => resource.sid
  	else
	    output = sql statement, :username => resource.username, :password => resource.password, :sid => resource.sid
	  end
	end
    Puppet.info(output) if resource.logoutput == :true
  end

  private

  def is_script?(statement)
  	statement[0] == '@'
  end

end
