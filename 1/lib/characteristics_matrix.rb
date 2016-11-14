# Contains all chacteristics vectors for ComparisonFiles
class CharacteristicsMatrix

  # Creates the characteristics matrix, each vector stored in its file
  def self.create_characteristic_matrix(files)
    CharacteristicsMatrix.calculate_characteristics(files)
  end

  private

  # Calculates the characteristics vectors for each file
  def self.calculate_characteristics(files)
    shingle_sets = files.map(&:shingles)

    universe = CharacteristicsMatrix.shingle_universe(shingle_sets)

    shingle_sets.each_with_index do |shingle_set, index|
      files[index].create_characteristic(shingle_set, universe)
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
