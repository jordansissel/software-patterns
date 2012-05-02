# Retry on Failure

Lots of functions fail nondeterministically; that is, they fail for reasons unrelated to the input.

For example, a HTTP GET may fail because the server is down temporarily.

## Implementing with begin/rescue/retry

Most errors in Ruby appear as exceptions, thus can be handled with 'rescue'. A
begin/rescue block supports 'retry' which causes the begin block to be
re-executed, kind of like a loop.

## Example runs

See `example.rb` for the code.

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
