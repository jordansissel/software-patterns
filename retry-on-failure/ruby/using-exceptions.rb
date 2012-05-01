# A simple example that does a HTTP fetch and retries a few times on failure.
require "ftw" # gem 'ftw'

class HTTPError < StandardError; end

def get(url)
  agent = FTW::Agent.new
  response = agent.get!(url)
  if (500..599).include?(response.status)
    raise HTTPError, "Status code #{response.status} from GET #{url}"
  end
  return response
end

if ARGV.length != 1
  puts "Usage: #{$0} <url>"
  exit 1
end

# This will fail because we're trying https on port 80.
url = ARGV[0]

tries = 5 # try 5 times before giving up.
begin
  # The 'get' method will raise an exception on a server error (503, etc)
  response = get(url)
rescue HTTPError => e
  # If there are tries left, retry the get.
  if tries > 0
    tries -= 1
    puts "Failed (#{e}). Retrying..."
    retry # this restarts the 'begin' block.
  else
    # We give up trying, reraise the exception
    raise
  end
end


puts "Response header:"
puts response.to_s

