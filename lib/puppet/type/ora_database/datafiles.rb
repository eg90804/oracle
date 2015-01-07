# encoding: UTF-8
newparam(:datafiles, :array_matching => :all) do
  include EasyType
  include EasyType::Mungers::Array

  desc 'One or more files to be used as datafiles.'

  
  to_translate_to_resource do | raw_resource|
    # raw_resource.column_data('datafiles')
  end

    
  on_apply do | command_builder | 
    "DATAFILE #{datafiles_string}"
  end

  private

  def datafiles_string
    value.join(',')
  end
    

end