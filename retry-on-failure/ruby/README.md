# Retry on Failure

Lots of functions fail nondeterministically; that is, they fail for reasons unrelated to the input.

For example, a HTTP GET may fail because the server is down temporarily.

## Implementation options

Most errors in Ruby appear as exceptions, thus can be handled with 'rescue'. A
begin/rescue block supports 'retry' which causes the begin block to be
re-executed, kind of like a loop:

```ruby
begin
  # some code that might fail
rescue SomeException
  tries -= 1
  retry if tries > 0 # restarts the 'begin' block
end
```

However, when I started generalizing this solution, I found that using
begin+rescue and an enumerable was a more flexible solution.

## Example Code

* See `example.rb` for the user code.
* See `lib/try.rb' for the 'try' implementation

This 'try' implementation uses an enumerable instead of Numeric value to clue
the number of attempts. This flows well:

## Specific Examples

### Try a few times:
```
try(5.times) do
  # some code
end
```

### Pass the enumerable value in:
```
try(5.times) do |iteration|
  puts "On try: #{iteration}"  # prints 'On try: 1', etc
  # some code
end
```

### Try forever until success

```
try do 
  # code ...
end
```

## Example runs

### Fail forever

```
% ruby -r ./lib/try -e 'try { raise "Uh oh" } '
Failed (Uh oh). Retrying in 0.01 seconds...
Failed (Uh oh). Retrying in 0.02 seconds...
Failed (Uh oh). Retrying in 0.04 seconds...
Failed (Uh oh). Retrying in 0.08 seconds...
Failed (Uh oh). Retrying in 0.16 seconds...
(this continues forever)
```


### Ran out of tries:

```
% ruby example.rb http://www.google.com/
Failed (Simulated random failure). Retrying in 0.01 seconds...
Failed (Simulated random failure). Retrying in 0.02 seconds...
Failed (Simulated random failure). Retrying in 0.04 seconds...
Failed (Simulated random failure). Retrying in 0.08 seconds...
Failed (Simulated random failure). Retrying in 0.16 seconds...
/home/jls/projects/software-patterns/retry-on-failure/ruby/lib/try.rb:47:in `try': Simulated random failure (HTTP::Error)
        from example.rb:14:in `<main>'
```

### First-time success:

```
% ruby example.rb http://www.google.com/
Response status: 200
```

### First fail, second success:

```
% ruby example.rb http://www.google.com/
Failed (Simulated random failure). Retrying in 0.01 seconds...
Response status: 200
```
