# Simple hash table with set-buckets
class HashTable

  attr_reader :buckets

  def initialize(size)
    @size = size
    @buckets = []
  end

  # Returns a bucket for a given hash value
  def get_bucket(hash)
    get_bucket_from_hash(hash)
  end

  # Adds an item given a hash value
  def add_item(item, hash)
    get_bucket_from_hash(hash).add(item)
    item.min_hashes << hash
  end

  # Returns all initialized buckets
  def buckets
    @buckets.compact
  end

  # Returns the union of all buckets containing this file
  def candidates_of(file)
    set = Set.new

    file.min_hashes.each do |hash|
      bucket = get_bucket_from_hash(hash)

      if bucket.include?(file)
        set.merge(bucket)
      end
    end

    set
  end

  private 

  # Returns a bucket given a hash value
  def get_bucket_from_hash(hash)
    ensure_bucket(hash)

    @buckets[hash % @size]
  end

  # Ensures that a bucket is initialized
  def ensure_bucket(hash)
    bucket = hash % @size

    unless @buckets[bucket]
      @buckets[bucket] = Set.new
    end
  end

end
