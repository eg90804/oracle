# encoding: UTF-8
newparam(:default_temporary_tablespace_name) do
  include EasyType
  
  desc 'The name of the default temporary tablespace'
  
  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('default_temporary_tablespace_name')
  end
      
  on_apply do | command_builder | 
    value
  end  

end