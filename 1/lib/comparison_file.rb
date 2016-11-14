# Wrapper for a comparison file
class ComparisonFile

  SIMILAR_THRESHOLD = 0.2
  SHINGLE_SIZE = 10

  attr_reader :name
  attr_reader :shingles, :vector
  attr_reader :similar_files

  def initialize(name, text)
    @name   = name
    @similar_files = []
    @vector = nil
    @shingles = Shingler.make_shingles(SHINGLE_SIZE, text)
  end

  # Create the sparse characteristic vector for this file,
  # marking each index with 1 if that shingle is included in the text
  def create_vector(shingle_set, universe_set)
    @vector = universe_set.each.map do |shingle|
      shingle_set.include?(shingle) ? 1 : 0
    end
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

      puts "#{self.to_s} and #{candidate.to_s} is #{similarity} similar"

      if similarity >= SIMILAR_THRESHOLD
        add_similar_file(candidate, similarity)
      end
    end  
  end

  # String representation of this class
  def to_s
    @name
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

  # Returns 1 if both files contains this shingle index
  def one_if_intersects_at(index, file)
    vector[index] & file.vector[index]
  end

  # Returns 1 if either files contains this shingle index
  def one_if_union_at(index, file)
    vector[index] | file.vector[index]
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
