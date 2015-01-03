# encoding: UTF-8
newproperty(:undo_tablespace_type) do
  include EasyType
  
  newvalues(:bigfile, :smallfile)
  defaultto :smallfile

  desc 'Use this to set the type default undo tablespace to create'

  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('undo_tablespace_type')
  end
  
  on_apply do | command_builder | 
    value
  end
  
end