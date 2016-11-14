# Compares files and calculates jaccard similarity between them
class Comparator

  def initialize(files)
    @files = files
    @locality = nil

    process_files
    compare_files

    print_buckets
    print_estimations
    print_similarities
  end

  private 

  # Calculates characteristics vectors, signatures and min-hashes
  def process_files
    CharacteristicsMatrix.create_characteristic_matrix(@files)
    SignatureMatrix.calculate_min_hashes(@files)
    @locality = LocalityHasher.new(@files)  
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

  # Prints which buckets contain which files
  def print_buckets
    @locality.print_buckets
  end

  # Prints estimations between similar files
  def print_estimations
    puts "Estimations"

    @files.each do |file|
      file.print_estimations
    end
  end

  # Prints similarities between similar files
  def print_similarities
    puts "Similarities"

    @files.each do |file|
      file.print_similarities
    end
  end

end
