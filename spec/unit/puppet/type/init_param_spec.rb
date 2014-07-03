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

	let(:attribute_class) { @class.attrclass(:name) }

	it 'should pick its value from element NAME' do
		raw_resource = InstancesResults['NAME','memory_target']
      		expect(attribute_class.translate_to_resource(raw_resource)).to eq 'MEMORY_TARGET'
    	end

	it 'should raise an error when name not found in raw_results' do
      		raw_resource = InstancesResults['NEMA','MY_NAME']
      		expect{attribute_class.translate_to_resource(raw_resource)}.to raise_error(RuntimeError)
    	end

    it 'should munge to uppercase' do
      @resource[:name] = 'sga_target'
      expect(@resource[:name]).to eq 'SGA_TARGET'
    end

    it 'should not accept a name with whitespace' do
      lambda { @resource[:name] = 'a a' }.should raise_error(Puppet::Error)
    end

    it 'should not accept an empty name' do
      lambda { @resource[:name] = '' }.should raise_error(Puppet::Error)
    end

    it_behaves_like 'an easy_type attribute', {
      :attribute          => :name,
      :result_identifier  => 'NAME',
      :raw_value          => 'MEMORY_TARGET',
      :test_value         => 'MEMORY_TARGET',
    }
  end

  describe ':value' do

    let(:attribute_name) { :value}

    context "when geting data from the system" do

      it 'should raise an error when name not found in raw_results' do
        raw_resource = InstancesResults['NAME','MY_NAME']
        expect{attribute_class.translate_to_resource(raw_resource)}.to raise_error(RuntimeError)
      end

      it 'should pick its value from element DISPLAY_VALUE' do
        raw_resource = InstancesResults['DISPLAY_VALUE','42G']
        expect(attribute_class.translate_to_resource(raw_resource)).to eq '42G' 
      end

    end

    context "base parameter settings" do
      it 'should accept a value and not modify it' do
        @resource[:value] = 'none'
        expect(@resource[:value]).to eq 'none'
      end

    end

  end

end
