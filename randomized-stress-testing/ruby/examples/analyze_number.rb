require "randomized"
require "rspec/stress_it"

RSpec.configure do |c|
  c.extend RSpec::StressIt
end

describe "number" do
  let(:number) { Randomized.number(0..200) }
  analyze_it "should be less than 100", [:number] do
    expect(number).to(be < 100)
  end
end
