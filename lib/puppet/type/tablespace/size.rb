newproperty(:size) do
  include EasyType
  include EasyType::Mungers::Size

  desc "The size of the tablespace"
  defaultto "500M"

  to_translate_to_resource do | raw_resource|
    raw_resource.column_data('BYTES').to_i
  end

  on_apply do | command_builder|
    size_statement = is_modified? ? 'resize' : 'size'
    if resource[:datafile].nil?
      "#{size_statement} #{resource[:size]}"
    else
      "datafile #{resource[:datafile]} #{size_statement} #{resource[:size]}"
    end
  end

  private
    def is_modified?
      retrieve != :absent
    end

end
