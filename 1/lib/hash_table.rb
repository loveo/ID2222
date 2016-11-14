# Simple hash table with set-buckets
class HashTable

  attr_reader :buckets

  def initialize(size)
    @size = size
    @buckets = []
    create_buckets
  end

  # Returns a bucket for a given hash value
  def get_bucket(hash)
    get_bucket_from_hash(hash)
  end

  # Adds an item given a hash value
  def add_item(item, hash)
    get_bucket_from_hash(hash).add(item)
  end

  # Returns the union of all buckets containing this file
  def candidates_of(file)
    set = Set.new

    buckets.each do |bucket|
      if bucket.include?(file)
        set.merge(bucket)
      end
    end

    set
  end

  private 

  # Creates empty buckets (sets)
  def create_buckets
    (1..@size).each do
      @buckets << Set.new
    end
  end

  # Returns a bucket given a hash value
  def get_bucket_from_hash(hash)
    @buckets[hash % @size]
  end

end
