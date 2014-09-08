newparam(:sid) do
  include EasyType

  desc "SID to connect to"

  to_translate_to_resource do | raw_resource|
  	raw_resource.column_data('SID')
  end

end

