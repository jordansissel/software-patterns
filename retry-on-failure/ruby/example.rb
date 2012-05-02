# A simple example that does a HTTP fetch and retries a few times on failure.
require "./lib/http"
require "./lib/try" # actually implements the begin/rescue/retry code.

if ARGV.length != 1
  puts "Usage: #{$0} <url>"
  exit 1
end

# This will fail because we're trying https on port 80.
url = ARGV[0]

response = try(20.times) { 
  # Simulate failure 70% of the time.
  raise HTTP::Error, "Random failure" if rand < 0.70
  HTTP.get(url) 
}

puts "Response header:"
puts response.to_s

