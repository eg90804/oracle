require 'utils/oracle_access'
require 'easy_type'

Puppet::Type.type(:parameter).provide(:simple) do
	include EasyType::Provider
	include ::Utils::OracleAccess

  desc "Manage Oracle Instance Parameters in an Oracle Database via regular SQL"

  mk_resource_methods

end

