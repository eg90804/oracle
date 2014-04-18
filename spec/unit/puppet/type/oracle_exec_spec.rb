#!/usr/bin/env rspec

require 'spec_helper'

oracle_exec = Puppet::Type.type(:oracle_exec)

describe oracle_exec do

  let(:attribute_class) {  @class.attrclass(attribute_name) }
  let(:attribute) {@resource.property(attribute_name)}


  before :each do
    @class = oracle_exec
    @provider = double 'provider'
    allow(@provider).to receive(:name).and_return(:simple)
    allow(Puppet::Type::Oracle_exec).to receive(:defaultprovider).and_return @provider
    @resource = @class.new({:name  => 'show_all'})
  end


  it 'should have :command be its namevar' do
    @class.key_attributes.should == [:command]
  end

  describe ':command' do

    it_behaves_like 'an easy_type attribute', {
      :attribute          => :command
    }
  end


end