#!/usr/bin/env rspec

require 'spec_helper'

init_param, = Puppet::Type.type(:init_param)

describe init_param do

  let(:attribute_class) {  @class.attrclass(attribute_name) }
  let(:attribute) {@resource.property(attribute_name)}


  before :each do
    @class = init_param 
    @provider = double 'provider'
    allow(@provider).to receive(:name).and_return(:simple)
    allow(Puppet::Type::Init_param).to receive(:defaultprovider).and_return @provider
    @resource = @class.new({:name  => 'MEMORY_TARGET'})
  end


  it 'should have :name be its namevar' do
    @class.key_attributes.should == [:name]
  end

  describe ':name' do

    it_behaves_like 'an easy_type attribute', {
      :attribute          => :name,
      :result_identifier  => 'NAME',
      :raw_value          => 'MEMORY_TARGET',
      :test_value         => 'MEMORY_TARGET',
    }
  end

end
