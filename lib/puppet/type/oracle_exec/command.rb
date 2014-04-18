newparam(:command) do
  include EasyType
  desc "The sql command to execute"

  isnamevar

  to_translate_to_resource do | raw_resource|
    ''
  end

end
