require "sequel"
require "./lib/try"

pg_hosts = ["pg-replica-a", "pg-replica-b", "pg-replica-c"]

# Try connecting to any database host.
database = try(pg_hosts) do |host|
  db = Sequel.connect("postgres://#{host}/example")
  # Sequel::Database#test_connection returns true if successful.
  # So return the db if we succeed, otherwise raises an error
  # in which case we will retry.
  db if db.test_connection
end
