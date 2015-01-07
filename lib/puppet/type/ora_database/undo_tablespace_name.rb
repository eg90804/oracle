# encoding: UTF-8
newparam(:undo_tablespace_name) do
  include EasyType
  
  desc 'The name of the undo tablespace'

  defaultto 'UNDOTBS1'
  
  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('undo_tablespace_name')
  end
      
  on_apply do | command_builder | 
    "undo tablespace #{value}"
  end  

end