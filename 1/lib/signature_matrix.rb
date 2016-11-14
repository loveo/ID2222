# Container for signature vectors
class SignatureMatrix

  attr_reader :files, :signature_matrix

  MIN_HASHES = 10

  def initialize(characteristics_matrix)
    @files = characteristics_matrix.files
    @signature_matrix = calculate_min_hashes
  end

  # Returns the estimated similarity between to files, using their signatures
  def similarity_between(file_one, file_two)
    index_one = signature_matrix.index(file_one)
    index_two = signature_matrix.index(file_two)

    SignatureMatrix.similarity_between_signatures(
      signature_matrix[index_one],
      signature_matrix[index_two]
    )
  end

  private

  # Calculates the min hashes to build a signature matrix
  def calculate_min_hashes
    min_hashes = []

    @files.each do |file|
      min_hashes << MinHasher.min_hashes(file.vector, MIN_HASHES)
    end

    min_hashes
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
