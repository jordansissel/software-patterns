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

  # Generate a random number of copies of a given example.
  # The idea is to take 1 `it` and run it N times to help tease out failures.
  # Of course, the teasing requires you have randomized `let` usage, for example:
  #
  #     let(:number) { Randomized.number(0..200) }
  #     it "should be less than 100" do
  #       expect(number).to(be < 100)
  #     end
  def stress_it2(example_name, *args, &block)
    Randomized.number(DEFAULT_ITERATIONS).times do |i|
      it(example_name + " [#{i}]", *args) do
        instance_eval(&block)
      end # it ...
    end # .times
  end 

  # Perform analysis on failure scenarios of a given example
  #
  # This will run the given example a random number of times and aggregate the
  # results. If any failures occur, the spec will fail and a report will be
  # given on that test.
  #
  # Example spec:
  #
  #     let(:number) { Randomized.number(0..200) }
  #     fuzz "should be less than 100" do
  #       expect(number).to(be < 100)
  #     end
  #
  # Example report:
  def analyze_it(name, variables, &block)
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
        raise Analysis.new(results)
      end
    end
  end

  class Analysis < StandardError
    def initialize(results)
      @results = results
    end

    def total
      @results.reduce(0) { |m, (k,v)| m + v.length }
    end

    def success_count
      if @results.include?(:success)
        @results[:success].length
      else
        0
      end
    end

    def percent(count)
      return (count + 0.0) / total
    end

    def percent_s(count)
      return sprintf("%.2f%%", percent(count) * 100)
    end

    def to_s
      report = ["#{percent_s(success_count)} tests successful of #{total} tests"]
      if success_count < total
        report << "Failure analysis:"
        report += @results.sort_by { |k,v| -v.length }.reject { |k,v| k == :success }.collect do |k, v|
          sample = v.sample(5).collect { |v| v.first }.join(", ")
          [ 
            "  #{percent_s(v.length)} -> [#{v.length}] #{k}",
            "    Sample exception:",
            v.sample(1).first[1].to_s.gsub(/^/, "      "),
            "    Samples causing #{k}:",
            *v.sample(5).collect { |state, _exception| "      #{state}" }
          ]
        end.flatten
      end
      report.join("\n")
    end
  end
end # module RSpec::StressIt
