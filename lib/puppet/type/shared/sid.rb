newparam(:sid) do
  include EasyType
  include EasyType::Mungers::Upcase

  desc "SID to connect to"

  to_translate_to_resource do | raw_resource|
  	raw_resource.column_data('SID').upcase
  end

end

