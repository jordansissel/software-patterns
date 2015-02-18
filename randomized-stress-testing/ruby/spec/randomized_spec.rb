require "randomized"
require "rspec/stress_it"

RSpec.configure do |c|
  c.extend RSpec::StressIt
end

describe Randomized do
  describe "#text" do
    context "with no arguments" do
      it "should raise ArgumentError" do
        expect { subject.text }.to(raise_error(ArgumentError))
      end
    end

    context "with 1 length argument" do
      subject { described_class.text(length) }

      context "that is positive" do
        let(:length) { rand(1..1000) }
        stress_it "should give a string with that length" do
          expect(subject).to(be_a(String))
          expect(subject.length).to(eq(length))
        end
      end

      context "that is negative" do
        let(:length) { -1 * rand(1..1000) }
        stress_it "should raise ArgumentError" do
          expect { subject }.to(raise_error(ArgumentError))
        end
      end
    end

    context "with 1 range argument" do
      let(:start)  { rand(1..1000) }
      let(:length) { rand(1..1000) }
      subject { described_class.text(range) }

      context "that is ascending" do
        let(:range) { start .. (start + length) }
        stress_it "should give a string within that length range" do
          expect(subject).to(be_a(String))
          expect(range).to(include(subject.length))
        end
      end

      context "that is descending" do
        let(:range) { start .. (start - length) }
        stress_it "should raise ArgumentError" do
          expect { subject }.to(raise_error(ArgumentError))
        end
      end
    end
  end

  describe "#character" do
    subject { described_class.character }
    stress_it "returns a string of length 1" do
      expect(subject.length).to(be == 1)
    end
  end

end 
