#!/usr/bin/env python

import json
from json import JSONEncoder

class Secret(object):
  def __init__(self, value):
    def valuefunc():
      return value
    self.value = valuefunc

  def __repr__(self):
    return "<secret>"

  def __str__(self):
    return repr(self)
    
# Provide a custom 'default' encoder method to cover 
# objects of type 'Secret'
jsenc = JSONEncoder()
def secretjson(obj):
  if isinstance(obj, Secret):
    return repr(obj)
  return jsenc.default(obj)


params = {
  "q": "hello world",
  "user": "jordan",
  "password": "nobody will guess me"
}

# Override the 'password' param as a Secret.
# this would be common if you get your params from wsgi, for example.
params["password"] = Secret(params["password"])

print params["password"]
print repr(params["password"])
print params["password"].value()
print json.dumps(params, default=secretjson)
