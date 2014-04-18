require 'utils/oracle_access'
require 'easy_type'

Puppet::Type.type(:oracle_exec).provide(:simple) do
  include EasyType::Provider
  include ::Utils::OracleAccess

  desc "Execute any sql command through puppet"

  mk_resource_methods

end

