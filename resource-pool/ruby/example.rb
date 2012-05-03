require "./lib/pool"

require "sequel"
Thread.abort_on_exception = true

def slowquery(db)
  # Simulates a slow query, just sleeps, really.
  puts "#{db.object_id}: In slow query (#{db})"
  sleep 1
end

# limit maximum of number resources in the pool.
# You can omit the size to make an infinite-sized pool.
pool = Pool.new(5) 

dburls = [ "sqlite://test1.db", "sqlite://test2.db", "sqlite://some/bad/path" ]

15.times do
  # Get a database connection and make sure it works before continuing.
  begin
    # Fetch a resource from the pool. If nothing is available and the pool is
    # not full, pick a random database URL and and use it. Otherwise, this fetch
    # call will block until the pool has an available resource.
    db = pool.fetch { Sequel.connect(dburls.shuffle.first) }

    # Test the connection to verify it still works (see Sequel::Database#test_connection)
    # If this fails, we'll catch the exception and remove this known-broken
    # database connection from the pool.
    db.test_connection
  rescue Sequel::DatabaseConnectionError => e
    puts "Database failed (#{db.inspect}), but will try another. Error was: #{e.class}"
    #p :busy => pool.instance_eval { @busy }, :available => pool.instance_eval { @available }
    pool.remove(db)

    # Now retry the fetch, which possibly will create a new database connection to replace
    # the broken one we just removed.
    retry
  end

  # Run a slow query in a separate thread.
  Thread.new(db) do |db|
    slowquery(db) 

    # Notify the pool that this resource is free again.
    pool.release(db)
  end

  # Sleep a bit, pretending to do other work in the main thread here.
  sleep 0.1
end
