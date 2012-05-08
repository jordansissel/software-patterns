# This is not the best implemetation. This is the most naive implementation, I
# think, and is certainly the first thing that comes to my mind when I consider
# implementing an interval execution method.
#
# Example showing clock skew:
#
#   interval1(1) { puts Time.now.to_f; sleep 0.1 }
def interval1(time, &block)
  while true
    # The 'block.call' obviously takes some time, and this implementation
    # ignores that time consumed! :(
    block.call
    sleep(time)
  end
end

