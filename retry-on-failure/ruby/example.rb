# A simple example that does a HTTP fetch and retries a few times on failure.
require "./lib/http" # implements the HTTP.get method
require "./lib/try" # actually implements the begin/rescue/retry code.

if ARGV.length != 1
  puts "Usage: #{$0} <url>"
  puts "Example: #{$0} http://www.google.com/"
  exit 1
end

url = ARGV[0]

response = try(5.times) do
  # Simulate failure 70% of the time.
  raise HTTP::Error, "Simulated random failure" if rand < 0.70
  HTTP.get(url) 
end

puts "Response status: #{response.status}"

