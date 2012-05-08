$: << File.dirname(__FILE__)
require "examples/interval1"
require "examples/interval2"
require "examples/interval3"

if ARGV.length != 1 or !["1", "2", "3"].include?(ARGV.first)
  puts "Usage: #{$0} <1|2|3>"
  exit 1
end

func = "interval#{ARGV[0]}"

interval = 1

boot = nil # boot time, will be recorded later.
start = Time.now
count = 0
method(func).call(interval) do
  # pretend to do work that takes a while to illustrate skew problems.
  sleep 0.1

  # Skip first iteration
  if count > 0
    duration = Time.now - start
    start = Time.now

    skew = ((Time.now - boot) - (interval * count))
    #p :duration => duration, :skew => sprintf("%.6f", skew), :count => count, :avgskew => sprintf("%.6f", skew / count)
    p :duration => duration, :skew => skew, :count => count, :avgskew => skew / count
  else
    boot = Time.now
  end
  count += 1
end
