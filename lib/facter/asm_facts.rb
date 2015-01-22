$:.unshift(Pathname.new(__FILE__).parent.parent.parent.parent + 'easy_type/lib')
$:.unshift(Pathname.new(__FILE__).parent.parent)
require 'facter'
require 'puppet'
require 'puppet/type/ora_asm_diskgroup'
require 'puppet/type/ora_asm_volume'

Facter.add("ora_asm_diskgroups") do
  setcode do
    ::Resources::OraAsmDiskgroup.index
  end
end

Facter.add("ora_asm_volumes") do
  setcode do
    ::Resources::OraAsmVolume.index
  end
end

