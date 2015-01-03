# encoding: UTF-8
newproperty(:extent_management) do
  include EasyType
  desc 'Use this setting to create a locally managed SYSTEM tablespace'

  newvalue(:local)  

  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('extent_management')
  end

  on_apply do | command_builder | 
    "extent management #{value}"
  end
  
end