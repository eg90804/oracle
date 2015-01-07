# encoding: UTF-8
newparam(:undo_tablespaces_datafiles, :array_matching => :all) do
  include EasyType
  include EasyType::Mungers::Array

  desc 'One or more files to be used as for undo tablespace. '
  
  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('undo_tablespaces_datafiles')
  end

    
  on_apply do | command_builder | 
    if value
      "DATAFILE #{undo_tablespaces_datafiles_string}"
    end
  end

  private

  def undo_tablespaces_datafiles_string
    value.join(',')
  end
    

end