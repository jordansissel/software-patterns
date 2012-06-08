require "ap"
require "./lib/secret2"

# This is an example of a common case. Holding a secret in an instance variable
# of an object, then printing or logging that object.
class User
  attr_accessor :name
  attr_accessor :password

  def initialize(name, password)
    @name = name
    @password = Secret2.new(password)
  end
end # def User

# Example with 'inspect'
jordan = User.new("jordan", "my password")
puts jordan.inspect

require "logger"
logger = Logger.new(STDOUT)
logger.info(jordan)

ap jordan

puts "The secret: #{jordan.password.value}"
