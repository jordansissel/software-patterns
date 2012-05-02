# Public: try a block of code until either it succeeds or we give up.
#
# enumerable - an Enumerable or omitted, #each is invoked and is tried that
#   number of times. If this value is omitted or nil, we will try until
#   success with no limit on the number of tries.
#
# Returns the return value of the block once the block succeeds.
# Raises the last seen exception if we run out of tries.
#
# Examples
#
#   # Try 10 times
#   response = try(10.times) { Net::HTTP.get_response("google.com", "/") }
#
#   # Try many times, yielding the value of the enumeration to the block.
#   # This allows you to try different inputs.
#   response = try([0, 2, 4, 6]) { |val| 50 / val }
#   
#   Output: 
#   Failed (divided by 0). Retrying in 0.01 seconds...
#   => 25
#
#
#   # Try forever
#   return_value = try { ... }
#
# The above will try fetching http://google.com/ at most 10 times, breaking
# after the first non-exception return.
def try(enumerable=nil, &block)
  if block.arity == 0
    # If the block takes no arguments, give none
    procedure = lambda { |val| block.call }
  else
    # Otherwise, pass the current 'enumerable' value to the block.
    procedure = lambda { |val| block.call(val) }
  end

  last_exception = nil

  # Retry after a sleep to be nice.
  backoff = 0.01
  backoff_max = 2.0

  # Try forever if enumerable is nil.
  if enumerable.nil?
    enumerable = Enumerator.new do |y| 
      a = 0
      while true
        a += 1
        y << a
      end
    end
  end

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
