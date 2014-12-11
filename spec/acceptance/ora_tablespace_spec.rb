require_relative '../spec_helper_acceptance'
require_relative '../support/shared_acceptance_specs'


describe 'ora_tablespace' do

  it_behaves_like "an ensurable resource", {
    :resource_name      => 'ora_tablespace',
    :present_manifest   => "ora_tablespace{test: ensure=>'present', logging=>'yes', size=> '5M'}",
    :change_manifest    => "ora_tablespace{test: ensure=>'present', logging=>'no', size=> '5M'}",
    :absent_manifest    => "ora_tablespace{test: ensure=>'absent'}",
  }
end
