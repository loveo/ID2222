# Generates hash functions and calculates min-hashes
class MinHasher

  # Start values for hash constants
  HASH_A = 2
  HASH_B = 3
  HASH_C = 979757 # Prime number

  # Returns the first <amount> of min-hashes for a shinge set
  def self.min_hashes(shingles, amount)
    (0..amount).each.map do |index|
      min_hash_for(shingles, index + 1)
    end
  end

  private

  # Returns the min-hash for a shingle set and a specific hash-index
  def self.min_hash_for(shingles, hash_index)
    min_pair = MinPair.new(Float::INFINITY)

    shingles.each do |value|
      min_pair = calculate_min_pair(min_pair, value, hash_index)
    end

    min_pair.value
  end

  # Returns the current smallest pair of [hash-value, value]
  def self.calculate_min_pair(min_pair, value, hash_index)
    hash_value = hash(value, hash_index)

    if hash_value < min_pair.hash
      min_pair.set_values(hash_value, value)
    end

    min_pair
  end

  # Returns the hash of a shingle for a specific hash-index
  def self.hash(value, hash_index)
    ( (HASH_A * hash_index * value) + (HASH_B * hash_index) ) % HASH_C
  end

  # Wrapper class for a min pair (index and hash-value)
  class MinPair

    attr_reader :value, :hash

    def initialize(max_value)
      @value = max_value
      @hash  = max_value
    end

    def set_values(new_hash, new_value)
      @hash  = new_hash
      @value = new_value 
    end

  end

end
