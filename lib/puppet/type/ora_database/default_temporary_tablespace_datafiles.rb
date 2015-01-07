# encoding: UTF-8
newparam(:default_temporary_tablespace_datafiles, :array_matching => :all) do
  include EasyType
  include EasyType::Mungers::Array

  desc 'One or more files to be used as default_temporary_tablespace_datafiles.'

  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('default_temporary_tablespace_datafiles')
  end
    
  on_apply do | command_builder | 
    "DATAFILE #{default_temporary_tablespace_datafiles_string}"
  end

  private

  def default_temporary_tablespace_datafiles_string
    value.join(',')
  end
    
end