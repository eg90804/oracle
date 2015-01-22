newproperty(:password) do
  include EasyType
  desc "The password"

  to_translate_to_resource do | raw_resource|
    ''
  end

 on_create do| command_builder|
    "identified by #{value}"
  end

 on_modify do| command_builder|
    "identified by #{value}"
  end

end

