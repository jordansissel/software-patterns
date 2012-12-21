# Hiding secrets in Python

The purpose of this 'hiding' is documented [here, in the ruby implementation
readme](https://github.com/jordansissel/software-patterns/tree/master/dont-log-secrets/ruby/README.md)

    % python example1.py
    str(): <secret>
    repr(): '<secret>'
    .value(): nobody will guess me
    json.dumps(): {"q": "hello world", "password": "<secret>", "user": "jordan"}

As you can see above, you won't accidentally ship the secret to a logfile or
other debugging tool.
