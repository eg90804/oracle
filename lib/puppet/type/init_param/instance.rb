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

<<<<<<< Updated upstream:lib/puppet/type/init_param/instance.rb

=======
>>>>>>> Stashed changes:lib/puppet/type/init_param/for_instance.rb
end

