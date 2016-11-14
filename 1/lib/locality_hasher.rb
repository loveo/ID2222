# Calculates which files are candidates and should be compared
class LocalityHasher

  ROWS_PER_BAND = 5
  BANDS         = 2
  TABLE_SIZE    = 2

  attr_reader :files

  def initialize(signature_matrix)
    @files = signature_matrix.files
    @table = HashTable.new(TABLE_SIZE)
    place_files_in_buckets
  end

  # Gets the candidates of a file exluding the given file
  def candidates_of(file)
    # use signature vector
    @table.get_bucket(LocalityHasher.band_hash(file.vector, 0)).delete(file)
  end

  # Helper method to print bucket contents
  def print_buckets
    @table.buckets.each_with_index do |bucket, index|
      puts "Bucket ##{index + 1}"
      puts bucket.each.map(&:to_s)
      puts ""
    end
  end

  private 

  # Places all files in its buckets
  def place_files_in_buckets
    @files.each do |file|
      place_file_in_buckets(file)
    end
  end

  # Places a given file in its buckets
  def place_file_in_buckets(file)
    (0..BANDS).each do |band|
      @table.add_item(file, LocalityHasher.band_hash(file.vector, band))
    end
  end

  # Returns the sum of exponentials of a band (x1 + x2^2 + x3^3 ... )
  def self.band_hash(vector, band)
    sub_vector = vector[band * ROWS_PER_BAND, ROWS_PER_BAND]

    hash_values = sub_vector.each_with_index.map do |value, index| 
      value ** (index + 1) 
    end

    hash_values.inject(:+)
  end

end
