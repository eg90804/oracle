newparam(:lb_advisory) do
  include EasyType

  desc "Goal for the Load Balancing Advisory. "

  newvalues( :none, :service_time, :throughput)

end


