newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  desc "The parameter name"

  isnamevar


  to_translate_to_resource do | raw_resource|
    sid = raw_resource.column_data('SID')
    parameter_name = raw_resource.column_data('NAME').upcase 
    "#{sid}/#{parameter_name}"
	end

end

