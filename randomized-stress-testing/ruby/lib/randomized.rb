# A collection of methods intended for use in randomized testing.
module Randomized
  # Generates text with random characters of a given length (or within a length range)
  #
  # * The length can be a number or a range `x..y`. If a range, it must be ascending (x < y)
  # * Negative lengths are not permitted and will raise an ArgumentError
  #
  # @param length [Fixnum or Range] the length of text to generate
  # @return [String] the 
  def self.text(length)
    if length.is_a?(Range)
      raise ArgumentError, "Requires ascending range, you gave #{length}." if length.end < length.begin
      raise ArgumentError, "A negative length is not permitted, I received range #{length}" if length.begin < 0

      length = integer(length)
    else
      raise ArgumentError, "A negative length is not permitted, I received #{length}" if length < 0
    end

    length.times.collect { character }.join
  end # def text

  # Generates a random character (A string of length 1)
  #
  # @return [String]
  def self.character
    # TODO(sissel): Add support to generate valid UTF-8. I started reading
    # Unicode 7 (http://www.unicode.org/versions/Unicode7.0.0/) and after much
    # reading, I realized I wasn't in my house anymore but had somehow lost
    # track of time and was alone in a field. Civilization had fallen centuries
    # ago. :P
    
    # Until UTF-8 is supported, just return a random lower ASCII character
    integer(32..127).chr
  end # def character

  # Return a random integer value within a given range.
  #
  # @param range [Range]
  def self.integer(range)
    raise ArgumentError, "Range not given, got #{range.class}: #{range.inspect}" if !range.is_a?(Range)
    rand(range)
  end # def integer

  # Return a random number within a given range.
  #
  # @param range [Range]
  def self.number(range)
    raise ArgumentError, "Range not given, got #{range.class}: #{range.inspect}" if !range.is_a?(Range)
    # Range#size returns the number of elements in the range, not the length of the range.
    # This makes #size return (abs(range.begin - range.end) + 1), and we want the length, so subtract 1.
    rand * (range.size - 1) + range.begin
  end # def number
   
  # Run a block a random number of times.
  #
  # @param range [Fixnum of Range] same meaning as #integer(range)
  def self.iterations(range, &block)
    range = 0..range if range.is_a?(Numeric)
    if block_given?
      integer(range).times(&block)
      nil
    else
      integer(range).times
    end
  end # def iterations
end
