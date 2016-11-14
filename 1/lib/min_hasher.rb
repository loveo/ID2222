# Generates hash functions and calculates min-hashes
class MinHasher

  # Start values for hash constants
  HASH_A = 2000
  HASH_B = 3333
  HASH_C = 979757 # 89989897 # Prime number

  # Returns the first <amount> of min-hashes for a sparse vector
  def self.min_hashes(vector, amount)
    (0..amount).each.map do |index|
      min_hash_for(vector, index + 1)
    end
  end

  private

  # Returns the min-hash (row value) for a vector and a specific hash-index
  def self.min_hash_for(vector, hash_index)
    min_pair = MinPair.new(vector.length)

    vector.each_with_index do |value, index|
      unless value == 0
        min_pair = calculate_min_pair(min_pair, index, hash_index)
      end
    end

    min_pair.index
  end

  # Returns the current smallest pair of [hash-value, index]
  def self.calculate_min_pair(min_pair, index, hash_index)
    hash_value = hash(index, hash_index)

  #    puts "Old hash=#{min_pair.hash}, new hash=#{hash_value}"

    if hash_value < min_pair.hash
      min_pair.set_values(hash_value, index)
    end

    min_pair
  end

  # Returns the hash of a row for a specific hash-index
  def self.hash(index, hash_index)
    ( (HASH_A * hash_index * index) + (HASH_B * hash_index) ) % HASH_C
  end

  # Wrapper class for a min pair (index and hash-value)
  class MinPair

    attr_reader :index, :hash

    def initialize(max_value)
      @index = max_value
      @hash  = max_value
    end

    def set_values(new_hash, new_index)
      @hash = new_hash
      @index = new_index 
    end

  end

end
