# encoding: UTF-8
newproperty(:default_tablespaces_datafiles, :array_matching => :all) do
  include EasyType
  include EasyType::Mungers::Array

  desc 'One or more files to be used as for the default tablespace. '

  
  to_translate_to_resource do | raw_resource|
    # raw_resource.column_data('default_tablespaces_datafiles')
  end

    
  on_apply do | command_builder | 
    "DATAFILE #{default_tablespaces_datafiles_string}"
  end

  private

  def default_tablespaces_datafiles_string
    value.join(',')
  end
    

end