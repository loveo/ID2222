# Wrapper for a comparison file
class ComparisonFile

  SIMILAR_THRESHOLD = 0.01
  SHINGLE_SIZE      = 10

  attr_reader :name
  attr_reader :representation
  attr_reader :similar_files

  def initialize(name, text)
    @name           = name
    @similar_files  = []
    @representation = FileRepresentation.new

    @representation.set_shingles(Shingler.make_shingles(SHINGLE_SIZE, text))
  end

  # Creates the sparse characteristic vector for this file,
  # marking each index with 1 if that shingle is included in the text
  def create_characteristic(shingle_set, universe_set)
    characteristic = universe_set.each.map do |shingle|
      shingle_set.include?(shingle) ? 1 : 0
    end

    @representation.set_characteristic(characteristic)
  end

  # Sets the signature vector of this file
  def set_signature_vector(signature_vector)
    @representation.set_signature(signature_vector)
  end

  # Calculates the Jaccard similarity between this file and another file
  def similarity_to(file)
    intersection = union = 0

    (0..vector.length - 1).each do |index|
      intersection += one_if_intersects_at(index, file)
      union        += one_if_union_at(index, file)
    end

    intersection.to_f / union.to_f
  end

  # Compares this file to a list of candidates
  def compare_to_candidates(candidates)
    candidates.each do |candidate|
      similarity = similarity_to(candidate)

      if similarity >= SIMILAR_THRESHOLD
        add_similar_file(candidate, similarity)
      end
    end  
  end

  # String representation of this class
  def to_s
    @name
  end

  # Getter for characteristics vector
  def vector
    @representation.characteristic
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

  # Prints the estimated similarites
  def print_estimations
    puts to_s

    if similar_files.empty?
      puts ' - has no similar files'
    else
      similar_files.each do |similar_file|
        puts " - has an estimated similarity of" +
             " #{similar_file.get_estimation_to(self)}" + 
             " to #{similar_file.file.to_s}"
      end
    end
  end

  private

  # Marks two files as similar, adding them in each files list
  def add_similar_file(file, similarity)
    similar_files      << SimilarFile.new(file, similarity)
    file.similar_files << SimilarFile.new(self, similarity)
  end

  # Returns 1 if both files contains this shingle index
  def one_if_intersects_at(index, file)
    vector[index] & file.vector[index]
  end

  # Returns 1 if either files contains this shingle index
  def one_if_union_at(index, file)
    vector[index] | file.vector[index]
  end

  # Logical class for different file representations
  class FileRepresentation

    attr_reader :shingles, :characteristic, :signature

    def initialize
      @shingles       = nil
      @characteristic = nil
      @signature      = nil
    end

    def set_shingles(shingles)
      @shingles = shingles
    end

    def set_characteristic(characteristic)
      @characteristic = characteristic
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

    # Returns the estimated similarity between the two files
    def get_estimation_to(this_file)
      SignatureMatrix.similarity_between(this_file, file)
    end

  end

end
