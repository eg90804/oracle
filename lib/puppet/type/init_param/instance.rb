newparam(:instance) do
  include EasyType
  include EasyType::Validators::Name
  include EasyType::Mungers::Upcase
  desc "The instance name"

  isnamevar

  defaultto 'default'

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('INSTANCE_NAME').upcase
  end


end

