# A class for holding a secret. The main goal is to prevent the common mistake
# of accidentally logging or printing passwords or other secrets.
class Secret
  # Initialize a new secret with a given value.
  #
  # value - anything you want to keep secret from loggers, etc.
  def initialize(value)
    @value = value
  end # def initialize

  # Emit simply "<secret>" when printed or logged.
  def to_s
    return "<secret>"
  end # def to_s

  alias_method :inspect, :to_s

  # Get the secret value.
  def value
    return @value
  end # def value
end # class Secret

