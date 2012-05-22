require "thread"

class Supervisor
  def initialize(*args, &block)
    @args = args
    @block = block

    run
  end # def initialize

  def run
    while true
      task = Task.new(*@args, &@block)
      begin
        puts :result => task.wait
      rescue => e
        puts e
        puts e.backtrace
      end
    end
  end # def run

  class Task
    def initialize(*args, &block)
      # A queue to receive the result of the block
      @queue = Queue.new
      @thread = Thread.new(@queue, *args) do |queue, *args|
        begin
          result = block.call(*args)
          queue << [:return, result]
        rescue => e
          queue << [:exception, e]
        end
      end # thread
    end # def initialize

    def wait
      @thread.join
      reason, result = @queue.pop

      if reason == :exception
        #raise StandardError.new(result)
        raise result
      else
        return result
      end
    end # def wait
  end # class Supervisor::Task
end # class Supervisor

def supervise(&block)
  Supervisor.new(&block)
end # def supervise
