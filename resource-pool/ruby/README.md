# Pooled resources

Frequently, you will have a dynamic set of resources that can answer requests.

For example, multiple web servers that can answer the same query, or multiple
read-only database backends, etc.

## Implementation options

TODO(sissel): To be written.

## Example Code

* See [`example.rb`](https://github.com/jordansissel/software-patterns/blob/master/resource-pool/ruby/example.rb) for the sample user code.
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
