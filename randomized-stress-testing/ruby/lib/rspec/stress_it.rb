
require "rspec/core"

module RSpec::StressIt
  DEFAULT_ITERATIONS = 1..1000
  def stress_it(*args, &block)
    it(*args) do
      # Run the block of an example many times
      # You can control the iteration count with `let(:stress_iterations) { ... }`
      (respond_to?(:stress_iterations) ? stress_iterations : Randomized.number(DEFAULT_ITERATIONS)).times do
        instance_eval(&block)

        # clear the internal rspec `let` cache this lets us run a test
        # repeatedly with new `let` evaluations
        @__memoized = {}
      end
    end
  end
end
