require 'ora_utils/oracle_access'
require 'easy_type'

Puppet::Type.type(:ora_database).provide(:simple) do
  include EasyType::Provider
  include ::OraUtils::OracleAccess


  desc "Manage an Oracle Database"

  mk_resource_methods

end

