require 'utils/oracle_access'
require 'easy_type/helpers'

Puppet::Type.type(:oracle_exec).provide(:sqlplus) do
  include Utils::OracleAccess
  include EasyType::Helpers
  include Puppet::Util::Logging

  mk_resource_methods

  def flush
    output = sql statement, :username => resource.username, :password => resource.password, :sid => resource.sid
    Puppet.info(output) if resource.logoutput == :true
  end


end
