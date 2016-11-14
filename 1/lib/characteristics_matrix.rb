# Contains all chacteristics vectors for ComparisonFiles
class CharacteristicsMatrix

  attr_reader :files

  def initialize(files)
    @files = files
    calculate_characteristics
  end

  private

  # Calculates the characteristics vectors for each file
  def calculate_characteristics
    shingle_sets = @files.map(&:shingles)

    universe = CharacteristicsMatrix.shingle_universe(shingle_sets)

    shingle_sets.each_with_index do |shingle_set, index|
      @files[index].create_vector(shingle_set, universe)
    end
  end

  # Returns the set of unique shingles across all texts
  def self.shingle_universe(shingles)
    universe_set = Set.new

    shingles.each do |shingle_set|
      universe_set.merge(shingle_set)
    end

    universe_set
  end

end
