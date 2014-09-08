newparam(:for_instance) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase
  desc "The instance name"

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('INST_ID').upcase
  end

  on_apply do | command_builder| 
	  "sid='#{for_instance}'"
	end

end

