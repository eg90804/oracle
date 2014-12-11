require_relative '../spec_helper_acceptance'
require_relative '../support/shared_acceptance_specs'


describe 'ora_service' do

  # it_behaves_like "an ensurable resource", {
  #   :resource_name      => 'ora_service',
  #   :present_manifest   => "ora_service{my_test: ensure=>'present'}",
  #   :absent_manifest    => "ora_service{my_test: ensure=>'absent'}"
    #TODO: We should be able to delete the service. Registerd as issue #32
  # }
  it "should be able to delete the service" do
    skip "Until github issue #32 is resolved"
  end
end
