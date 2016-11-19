# Wrapper for a comparison file
class ComparisonFile

  SHINGLE_SIZE = Settings::CONFIG.shingle_size

  attr_reader :name
  attr_reader :representation
  attr_reader :similar_files
  attr_reader :min_hashes

  def initialize(name, text)
    @name           = name
    @similar_files  = []
    @representation = FileRepresentation.new
    @min_hashes     = []

    @representation.set_shingles(Shingler.make_shingles(SHINGLE_SIZE, text))
  end

  # Sets the signature vector of this file
  def set_signature_vector(signature_vector)
    @representation.set_signature(signature_vector)
  end

  # Calculates the Jaccard similarity between this file and another file
  def similarity_to(file)
    union     = shingles.union(file.shingles)
    intersect = union.intersection(shingles)

    intersect.size.to_f / union.size.to_f
  end

  # Compares this file to a list of candidates
  def compare_to_candidates(candidates)
    candidates.each do |candidate|
      similarity = similarity_to(candidate)

      if similarity >= Settings::CONFIG.similarity
        add_similar_file(candidate, similarity)
      end
    end  
  end

  # String representation of this class
  def to_s
    @name
  end

  # Fetcher for signature vector
  def signature_vector
    @representation.signature
  end

  # Fetcher for shingles
  def shingles
    @representation.shingles
  end

  # Prints a readable version of the similar files
  def print_similarities
    puts to_s

    if similar_files.empty?
      puts ' - has no similar files'
    else
      similar_files.each do |similar_file|
        puts " - #{similar_file.to_s}"
      end
    end
  end

  private

  # Marks two files as similar, adding them in each files list
  def add_similar_file(file, similarity)
    similar_files      << SimilarFile.new(file, similarity)
    file.similar_files << SimilarFile.new(self, similarity)
  end

  # Logical class for different file representations
  class FileRepresentation

    attr_reader :shingles, :signature

    def initialize
      @shingles       = nil
      @signature      = nil
    end

    def set_shingles(shingles)
      @shingles = shingles
    end

    def set_signature(signature)
      @signature = signature
    end

  end

  # Wrapper for similar file
  class SimilarFile

    attr_reader :file, :similarity

    def initialize(file, similarity)
      @file = file
      @similarity = similarity
    end

    # String reperesentation of this class
    def to_s
      "is similar to #{@file} with #{@similarity} Jaccard similarity"
    end

  end

end
