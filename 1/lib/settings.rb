# Holder class for project settings
class Settings

  CONFIG = OpenStruct.new(
    table_size:     20000,  # number of buckets in hash table
    similarity:     0.8,    # similarity threshold between files
    min_hashes:     100,    # number of min hashes for signature matrix
    shingle_size:   10,     # size of shingles
    bands:          5,      # number of bands used in LSH
    rows_per_band:  10,     # rows per band in LSH
    pool_size:      8       # number of workers when calculating signatures
    )

  # Sets the similarity threshold if given as first argument
  def self.parse_similarity_arg
    similarity = ARGV.first.to_f

    CONFIG.similarity = similarity if similarity > 0
  end

end
