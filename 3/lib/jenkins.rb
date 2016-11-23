# Jenkins hash implementation
class Jenkins

  MAX_32_BIT = 4294967295

  # Returns the Jenkins hash value of a number
  def self.hash(number)
    hash = 0

    number.to_s.each do |digit|
      hash += digit.ord
      hash &= MAX_32_BIT
      hash += ((hash << 10) & MAX_32_BIT)
      hash &= MAX_32_BIT
      hash ^= hash >> 6
    end

    hash += (hash << 3 & MAX_32_BIT)
    hash &= MAX_32_BIT
    hash ^= hash >> 11
    hash += (hash << 15 & MAX_32_BIT)
    hash &= MAX_32_BIT

    hash
  end

end
