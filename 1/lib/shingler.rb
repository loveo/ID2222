# Creates shingle sets from texts
class Shingler

  # Returns the unique set of shingles from a text,
  # each shingle has <length> length
  def self.make_shingles(length, text)
    cut_into_shingles(length, prepare_text(text))
  end

  private

  # Replaces blank space(s) with underscore and turns text into lowercase
  def self.prepare_text(text)
    text.downcase.gsub(/(\s+)/, '_')
  end

  # Returns a set of shingles from a text
  def self.cut_into_shingles(length, text)
    shingle_set = Set.new

    (0...text.length - length).each do |index|
      shingle_set.add(hash_shingle(text[index, length]))
    end

    shingle_set
  end

  # Hashes a shingle into a 32bit int
  def self.hash_shingle(shingle)
    XXhash.xxh32(shingle)
  end

end
