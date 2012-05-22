require "./lib/supervise"

supervise do
  puts "OK"
  sleep 0.2
  if rand > 0.5
    raise "Failure"
  else
    "Success"
  end
end
