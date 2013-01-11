# Error Reporting

Errors in software happen for many reasons. Loosely, the following reasons:

* buggy code (invalid state)
* environmental problems (broken components)
* bad user input (invalid configuration or other input)

For most command-line tools and code libraries, any error is likely to give you
the same result: a confusing message and a big stack trace.

The error to report depends usually on the intended audience, which I'll
classify roughly here:

* developer: buggy code.
* admin: environmental problems.
* user: invalid input or configuration

Having those audiences defined, I think the following is true - each wants
exactly as much data, but no more, to identify and resolve the problem.
Preferrably presented in a way that is easily consumable.

* developer: structured dump of state (stack, inputs, etC)
* admin: identifying the failing component
* user: identify the problem in a human-readable way, recommend a fix.

TODO(sissel): implement exception-based errors for each type of audience.
