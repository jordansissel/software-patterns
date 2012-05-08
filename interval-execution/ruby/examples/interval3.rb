# This implementation tries to keep clock more accurately.
# Prior implementations still permitted skew, where as this one
# will attempt to correct for skew.
#
# The execution patterns of this method should be that 
# the start time of 'block.call' should always be at time T*interval
def interval3(time, &block)
  start = Time.now
  while true
    block.call
    duration = Time.now - start
    # Sleep only if the duration was less than the time interval
    if duration < time
      sleep(time - duration)
      start += time
    else
      # Duration exceeded interval time, reset the clock and do not sleep.
      start = Time.now
    end
  end # loop forever
end # def interval3
