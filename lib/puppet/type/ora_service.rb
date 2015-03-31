require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'ora_utils/oracle_access'
require 'ora_utils/title_parser'


module Puppet
  newtype(:ora_service) do
    include EasyType
    include ::OraUtils::OracleAccess
    extend ::OraUtils::TitleParser

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
      sql_on_all_database_sids "select name from service$ where deletion_date is null"
    end

    on_create do | command_builder |
      sql "exec dbms_service.create_service('#{service_name}', '#{service_name}')", :sid => sid
      if for_all_instances?
        sql "exec dbms_service.start_service('#{service_name}', dbms_service.all_instances)", :sid => sid
      else
        if is_cluster?
          instances.each do |n|
            sql "exec dbms_service.start_service('#{service_name}', '#{n}')", :sid => sid
          end
        else
          sql "exec dbms_service.start_service('#{service_name}')", :sid => sid
        end
      end
      new_services = current_services << service_name
      statement = set_services_command(new_services)
      command_builder.add(statement, :sid => sid)
    end
    
    on_modify do | command_builder |
      fail "Not implemented yet."
    end

    on_destroy do | command_builder |
      require 'ruby-debug'
      debugger
      new_services = current_services.delete_if {|e| e == service_name }
      statement = set_services_command(new_services)
      command_builder.add(statement, :sid => sid)
      sql "whenever sqlerror continue; exec dbms_service.disconnect_session('#{service_name}')", :sid => sid
      sql "whenever sqlerror continue; exec dbms_service.stop_service('#{service_name}', dbms_service.all_instances)", :sid => sid
      sql "exec dbms_service.delete_service('#{service_name}')", :sid => sid
    end

    map_title_to_sid(:service_name) { /^((@?.*?)?(\@.*?)?)$/}

    parameter :name
    parameter :service_name
    parameter :sid
    property  :instances

    private

      def is_cluster?
        instances.count > 0
      end

      def for_all_instances?
        instances == ['*']
      end

      def set_services_command(services)
        "alter system set service_names = '#{services.join('\',\'')}' scope=both"
      end

      def current_services
        provider.class.instances.map(&:service_name)
      end


  end
end
