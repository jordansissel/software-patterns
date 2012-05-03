require "./lib/pool"

require "sequel"
Thread.abort_on_exception = true

def slowquery(db)
  # Simulates a slow query, just sleeps, really.
  puts "#{db.object_id}: In slow query (#{db})"
  sleep 1
end

pool = Pool.new(5) # limit maximum of number resources in the pool.

dburls = [ "sqlite://test1.db", "sqlite://test2.db", "sqlite://some/bad/path" ]

15.times do
  # Get a database connection and make sure it works before continuing.
  begin
    # Fetch a resource from the pool. If nothing is available and the pool is
    # not full, pick a random database URL and and use it.
    db = pool.fetch { Sequel.connect(dburls.shuffle.first) }
    db.test_connection
  rescue Sequel::DatabaseConnectionError => e
    puts "Database failed (#{db.inspect}), but will try another. Error was: #{e.class}"
    #p :busy => pool.instance_eval { @busy }, :available => pool.instance_eval { @available }
    pool.remove(db)

    # Ahh but we should be using the 'try' pattern, shouldn't we? ;)
    retry
  end

  # Run a slow query in a separate thread.
  Thread.new(db) do |db|
    slowquery(db) 

    # Notify the pool that this resource is free again.
    pool.release(db)
  end

  # Sleep a bit.
  sleep 0.1
end
