# Public: try a block of code until either it succeeds or we give up.
#
# enumerable - an Enumerable, #each is invoked and is tried that number of times.
# block - the block
#
# Returns the return value of the block.
#
# Examples
#
#   response = try(10.times) { Net::HTTP.get_response("google.com", "/") }
#
# The above will try fetching http://google.com/ at most 10 times, breaking
# after the first non-exception return.
def try(enumerable, &block)
  if block.arity == 0
    # If the block takes no arguments, give none
    procedure = lambda { |val| block.call }
  else
    # Otherwise, pass the current 'enumerable' value to the block.
    procedure = lambda { |val| block.call(value) }
  end

  last_exception = nil

  # Retry after a sleep to be nice.
  backoff = 0.01
  backoff_max = 2.0

  # When 'enumerable' runs out of things, if we still haven't succeeded, we'll
  # reraise
  enumerable.each do |val|
    begin
      return procedure.call(val)
    rescue => e
      puts "Failed (#{e}). Retrying in #{backoff} seconds..."
      last_exception = e

      # Exponential backoff
      sleep(backoff)
      backoff = [backoff * 2, backoff_max].min unless backoff == backoff_max
    end
  end

  # generally make the exception appear from the 'try' method itself, not from
  # any deeply nested enumeration/begin/etc
  last_exception.set_backtrace(StandardError.new.backtrace)
  raise last_exception
end # def try
