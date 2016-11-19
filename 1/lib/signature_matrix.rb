# Creates and compares signature vectors
class SignatureMatrix

  attr_reader :files

  MIN_HASHES = Settings::CONFIG.min_hashes
  POOL_SIZE  = Settings::CONFIG.pool_size

  # Returns candidates that probably are similar to the file
  def self.filter_candidates(file, candidates)
    candidates.reject do |candidate|
      similarity_between(file, candidate) < Settings::CONFIG.similarity
    end
  end

  # Calculates the min hashes to build a signature matrix
  def self.calculate_min_hashes(files)
    queue = Queue.new
    files.each { |file| queue << file }
    workers = []

    (1..POOL_SIZE).each do
      workers << Thread.new { threaded_min_hashing(queue) }
    end

    workers.each(&:join)
  end

  private

  # Worker method for min hashing
  def self.threaded_min_hashing(queue)
    while not queue.empty?
      file = queue.pop
      puts "#{file.name}"

      file.set_signature_vector(
        MinHasher.min_hashes(file.shingles, MIN_HASHES)
        )
    end
  end

  # Returrns the estimated similarity between to files, using their signatures
  def self.similarity_between(file_one, file_two)
    similarity_between_signatures(
      file_one.signature_vector,
      file_two.signature_vector
      )
  end

  # Returns the fraction of components that are equal between two signatures
  def self.similarity_between_signatures(signature_one, signature_two)
    equal_components = 0

    signature_one.each_with_index do |value, index|
      if value == signature_two[index]
        equal_components += 1
      end
    end

    equal_components.to_f / signature_one.length.to_f
  end

end
