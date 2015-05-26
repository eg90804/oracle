require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'ora_utils/oracle_access'
require 'ora_utils/title_parser'
require 'ora_utils/commands'

module Puppet
  newtype(:ora_service) do
    include EasyType
    include ::OraUtils::OracleAccess
    extend ::OraUtils::TitleParser
    include ::OraUtils::Commands

    desc %q{
      This resource allows you to manage a service in an Oracle database.
      
       ora_service{'service_name':
        instances => [ 'inst1', 'inst2', 'inst3', .... ]
        }

      or for all instances

      ora_service{'service_name':
        instances => [ '*' ]
        }
    }

    ensurable

    set_command(:sql)

    to_get_raw_resources do
      sql_on_all_database_sids "select name from dba_services"
    end

    on_create do | command_builder |
      create_service
      nil
    end
    
    on_modify do | command_builder |
      fail "Not implemented yet."
    end

    on_destroy do | command_builder |
      remove_service
      nil
    end

    map_title_to_sid(:service_name) { /^((@?.*?)?(\@.*?)?)$/}

    parameter :name
    parameter :service_name
    parameter :sid
    property  :instances
    parameter :prefered_instances

    #
    # This will be implemented later
    # TODO: Add the implementation for these options
    # property  :clb_goal
    # parameter :aq_ha_notifications
    # parameter :cardinality
    # parameter :dtp
    # parameter :failover_delay
    # parameter :failover_method
    # parameter :failover_retries
    # parameter :failover_type
    # parameter :lb_advisory
    # parameter :management_policy
    # parameter :network_number
    # parameter :server_pool
    # parameter :service_role
    # parameter :taf_policy


    private

      def disconnect_service
        sql "exec dbms_service.disconnect_session('#{service_name}')", :sid => sid, :failonsqlfail => false, :parse => false
      end

      def create_service
        sql "exec dbms_service.create_service('#{service_name}', '#{service_name}')", :sid => sid, :failonsqlfail => false, :parse => false
        sql "exec dbms_service.start_service('#{service_name}', dbms_service.all_instances)", :sid => sid, :failonsqlfail => false, :parse => false
      end

      def remove_service
        sql "exec dbms_service.stop_service('#{service_name}', dbms_service.all_instances)", :sid => sid, :failonsqlfail => false, :parse => false
        sql "exec dbms_service.delete_service('#{service_name}')", :sid => sid, :failonsqlfail => false, :parse => false
      end

      def current_services
        @current_services ||= provider.class.instances.map(&:service_name).dup
      end

      def dbname
        sid.chop
      end

  end
end







