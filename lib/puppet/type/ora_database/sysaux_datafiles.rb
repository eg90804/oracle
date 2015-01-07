# encoding: UTF-8
newparam(:sysaux_datafiles, :array_matching => :all) do
  include EasyType

  desc 'Use this property if you are not using Oracle-managed files and you want to specify one or more datafiles for the SYSAUX tablespace.'

  to_translate_to_resource do | raw_resource|
  #  raw_resource.column_data('sysaux_datafiles')
  end

  on_apply do | command_builder | 
    "SYSAUX DATAFILE #{sysaux_datafiles_string}"
  end

  private

  def sysaux_datafiles_string
    value.join(',')
  end
    
end