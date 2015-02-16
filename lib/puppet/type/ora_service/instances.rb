require 'ora_utils/mungers'

newproperty(:instances, :array_matching => :all) do
  include EasyType

  desc = %q{A list of instance names to activate the service on.}

  defaultto []

end
