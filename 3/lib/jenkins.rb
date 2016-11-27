# Jenkins hash implementation
class Jenkins

  MAX_32_BIT = 4294967295

  # Returns the Jenkins hash value of a number
  def self.hash(number)
    hash = 0

    number.to_s.chars.each do |digit|
      hash = hash_digit(digit, hash)
    end

    finalize_hash(hash)
  end

  # Updates the hash for a digit
  def self.hash_digit(digit, hash)
    hash += digit.ord
    hash &= MAX_32_BIT
    hash += ((hash << 10) & MAX_32_BIT)
    hash &= MAX_32_BIT
    hash ^= hash >> 6
  end

  # Runs the final part of the hash algorithm
  def self.finalize_hash(hash)
    hash += (hash << 3 & MAX_32_BIT)
    hash &= MAX_32_BIT
    hash ^= hash >> 11
    hash += (hash << 15 & MAX_32_BIT)
    hash &= MAX_32_BIT
  end

end
