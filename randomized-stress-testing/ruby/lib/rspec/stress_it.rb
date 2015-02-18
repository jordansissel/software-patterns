# encoding: utf-8
require "rspec/core"

module RSpec::StressIt
  DEFAULT_ITERATIONS = 1..5000

  # Wraps `it` and runs the block many times. Each run has will clear the `let` cache.
  #
  # The intent of this is to allow randomized testing for fuzzing and stress testing
  # of APIs to help find edge cases and weird behavior.
  #
  # The default number of iterations is randomly selected between 1 and 1000 inclusive
  def stress_it(*args, &block)
    it(*args) do
      # Run the block of an example many times
      # You can control the iteration count with `let(:stress_iterations) { ... }`
      Randomized.number(DEFAULT_ITERATIONS).times do |i|
        # Run the block within 'it' scope
        instance_eval(&block)

        # clear the internal rspec `let` cache this lets us run a test
        # repeatedly with fresh `let` evaluations.
        # Reference: https://github.com/rspec/rspec-core/blob/5fc29a15b9af9dc1c9815e278caca869c4769767/lib/rspec/core/memoized_helpers.rb#L124-L127
        __memoized.clear
      end
    end # it ...
  end # def stress_it

  def stress_it2(example_name, *args, &block)
    # Run the block of an example many times
    # You can control the iteration count with `let(:stress_iterations) { ... }`
    Randomized.number(DEFAULT_ITERATIONS).times do |i|
      it(example_name + " [#{i}]", *args) do
        instance_eval(&block)
      end # it ...
    end # .times
  end 

  def fuzz(name, variables, &block)
    it(name) do
      results = Hash.new { |h,k| h[k] = [] }
      iterations = Randomized.number(DEFAULT_ITERATIONS)
      iterations.times do |i|
        state = Hash[variables.collect { |l| [l, __send__(l)] }]
        begin
          instance_eval(&block)
          results[:success] << [state, nil]
        rescue => e
          results[e.class] << [state, e]
        rescue Exception => e
          results[e.class] << [state, e]
        end

        # Clear `let` memoizations
        __memoized.clear
      end

      if results[:success] != iterations
        raise FuzzReport.new(results)
      end
    end
  end

  class FuzzReport < StandardError
    def initialize(results)
      @results = results
    end

    def total_count
      @results.reduce(0) { |m, (k,v)| m + v.length }
    end

    def success_count
      if @results.include?(:success)
        @results[:success].length
      else
        0
      end
    end

    def to_s
      percent = sprintf("%.2f%%",((success_count + 0.0) / total_count) * 100)
      report = ["#{percent} tests successful"]
      if total_count != success_count
        report << "Report by failure:"
        report += @results.sort_by { |k,v| v.length }.reject { |k,v| k == :success }.collect do |k, v|
          sample = v.sample(10).collect { |v| v.first }.join(", ")
          "[#{v.length}] #{k} - #{sample}"
        end
      end
      report.join("\n")
    end
  end
end # module RSpec::StressIt
