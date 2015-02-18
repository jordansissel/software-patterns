require "rspec/core"

module RSpec::StressIt
  DEFAULT_ITERATIONS = 1..1000

  # Wraps `it` and runs the block many times. Each run has will clear the `let` cache.
  #
  # The intent of this is to allow randomized testing for fuzzing and stress testing
  # of APIs to help find edge cases and weird behavior.
  #
  # The default number of iterations is randomly selected between 1 and 1000 inclusive
  # You can control the number of iterations by setting `let(:stress_iterations) { ... }` yourself.
  def stress_it(*args, &block)
    it(*args) do
      # Run the block of an example many times
      # You can control the iteration count with `let(:stress_iterations) { ... }`
      if respond_to?(:stress_iterations)
        stress_iterations
      else
        Randomized.number(DEFAULT_ITERATIONS)
      end.times do
        # Run the block within 'it' scope
        instance_eval(&block)

        # clear the internal rspec `let` cache this lets us run a test
        # repeatedly with fresh `let` evaluations.
        # Reference: https://github.com/rspec/rspec-core/blob/5fc29a15b9af9dc1c9815e278caca869c4769767/lib/rspec/core/memoized_helpers.rb#L124-L127
        @__memoized = {}
      end
    end # it ...
  end # def stress_it
end # module RSpec::StressIt
