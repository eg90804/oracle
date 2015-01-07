# encoding: UTF-8
newparam(:default_temporary_tablespace_type) do
  include EasyType
  
  newvalues(:bigfile, :smallfile)

  desc 'Use this to set the type default temporary tablespace to create'

  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('default_temporary_tablespace_type')
  end
  
  on_apply do | command_builder | 
    value
  end
  
end