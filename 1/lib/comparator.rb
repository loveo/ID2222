# Compares files and calculates jaccard similarity between them
class Comparator

  def initialize(files)
    @files = files
    @locality = nil
    
    process_files
    compare_files
  end

  private 

  # Calculates characteristics vectors, signatures and min-hashes
  def process_files
    matrix    = CharacteristicsMatrix.new(@files)
    signature = SignatureMatrix.new(matrix)
    @locality = LocalityHasher.new(signature)  
  end

  # Compare seach file to the others
  def compare_files
    @files.each do |file|
      compare_file(file)
    end
  end

  # Compares a given file to its candidates
  def compare_file(file)
    candidates = possible_candidates_for(file)
    file.compare_to_candidates(candidates)
  end

  # Returns possible candidates for this file
  def possible_candidates_for(file)
    @locality
      .candidates_of(file)
      .subtract(file.similar_files.map(&:file))
  end

end
