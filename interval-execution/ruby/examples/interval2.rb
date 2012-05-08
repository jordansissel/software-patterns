# This implementation tries to solve the problem identified in 'interval1'
# that is, the 'block.call' can consume time that skews the clock.
#
# Example:
#
#   interval2(1) { puts Time.now.to_f; sleep 0.1 }
def interval2(time, &block)
  while true
    # Keep track of how long 'block.call' took.
    start = Time.now
    block.call
    duration = Time.now - start

    # Now sleep 'interval' seconds less the 'duration' of the 'block.call'
    # unless the duration was longer than the interval, in which case
    # we do not sleep at all.
    sleep(time - duration) if duration > 0
  end
end

