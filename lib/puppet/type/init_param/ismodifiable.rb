newproperty(:ismodifiable) do
  include EasyType

  desc "can this parameter be changed for a running instance"
  newvalues(:yes, :no)

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('MOD').downcase.to_sym
  end
end
