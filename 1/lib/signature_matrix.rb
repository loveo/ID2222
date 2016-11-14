# Creates and compares signature vectors
class SignatureMatrix

  attr_reader :files

  MIN_HASHES = 100

  # Returns the estimated similarity between to files, using their signatures
  def self.similarity_between(file_one, file_two)
    SignatureMatrix.similarity_between_signatures(
      file_one.signature_vector,
      file_two.signature_vector
      )
  end

  # Calculates the min hashes to build a signature matrix
  def self.calculate_min_hashes(files)
    files.each do |file|
      file.set_signature_vector(
        MinHasher.min_hashes(file.vector, MIN_HASHES)
        )
    end
  end

  private

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
