# Pooled resources

Frequently, you will have a dynamic set of resources that can answer requests.

For example, multiple web servers that can answer the same query, or multiple
read-only database backends, etc.

## Implementation options

Worker and Thread pool implementations are quite plentiful, and may suit your
needs here. However, I'm looking specifically to solve a more general
"resource" pool.

The work flow I wanted here was:

1. Get a resource from the pool
  * if none available, create a new one or block until one is available
2. Do something with this resource
3. Release the resource back to the pool
4. Remove bad resources (a database died, for example)

With this flow, we can implement thread pools, workers, etc, but also implement
connection pooling, etc.

## Example Code

* See [`example.rb`](https://github.com/jordansissel/software-patterns/blob/master/resource-pool/ruby/example.rb) for the sample user code which maintaines a pool of database connections.
* See [`lib/pool.rb'](https://github.com/jordansissel/software-patterns/blob/master/resource-pool/ruby/lib/pool.rb) for the 'pool' implementation

## Specific Examples

### Active pool of healthy database connections

```
% ruby example.rb
Database failed (#<Sequel::SQLite::Database: "sqlite://some/bad/path">), but will try another. Error was: Sequel::DatabaseConnectionError
14363500: In slow query (#<Sequel::SQLite::Database:0x00000001b656d8>)
14392280: In slow query (#<Sequel::SQLite::Database:0x00000001b737b0>)
14407200: In slow query (#<Sequel::SQLite::Database:0x00000001b7ac40>)
Database failed (#<Sequel::SQLite::Database: "sqlite://some/bad/path">), but will try another. Error was: Sequel::DatabaseConnectionError
14456720: In slow query (#<Sequel::SQLite::Database:0x00000001b92f20>)
14473340: In slow query (#<Sequel::SQLite::Database:0x00000001b9b0f8>)
=> Pool is full and nothing available. Waiting for a release...
14363500: In slow query (#<Sequel::SQLite::Database:0x00000001b656d8>)
=> Pool is full and nothing available. Waiting for a release...
14392280: In slow query (#<Sequel::SQLite::Database:0x00000001b737b0>)
=> Pool is full and nothing available. Waiting for a release...
14407200: In slow query (#<Sequel::SQLite::Database:0x00000001b7ac40>)
=> Pool is full and nothing available. Waiting for a release...
14456720: In slow query (#<Sequel::SQLite::Database:0x00000001b92f20>)
=> Pool is full and nothing available. Waiting for a release...
14473340: In slow query (#<Sequel::SQLite::Database:0x00000001b9b0f8>)
=> Pool is full and nothing available. Waiting for a release...
14363500: In slow query (#<Sequel::SQLite::Database:0x00000001b656d8>)
=> Pool is full and nothing available. Waiting for a release...
14392280: In slow query (#<Sequel::SQLite::Database:0x00000001b737b0>)
=> Pool is full and nothing available. Waiting for a release...
14407200: In slow query (#<Sequel::SQLite::Database:0x00000001b7ac40>)
=> Pool is full and nothing available. Waiting for a release...
14456720: In slow query (#<Sequel::SQLite::Database:0x00000001b92f20>)
=> Pool is full and nothing available. Waiting for a release...
14473340: In slow query (#<Sequel::SQLite::Database:0x00000001b9b0f8>)
```
