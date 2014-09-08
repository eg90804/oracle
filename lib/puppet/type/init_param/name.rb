newparam(:name) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase
  desc "The parameter name"

  isnamevar


  to_translate_to_resource do | raw_resource|
    sid = raw_resource.column_data('SID').upcase
    instance = raw_resource.column_data('INSTANCE_NAME').upcase
    parameter_name = raw_resource.column_data('NAME').upcase 
    "#{sid}/#{instance}/#{parameter_name}"
	end

end

