# Read files from arguments
class FileReader

  # Reads files from argv
  def self.read_from_argv
    read_files(ARGV)
  end

  # Returns a list of Comparison Files from a list of file names
  def self.read_files(file_names)
    file_names.map do |file_name|
      read_file(file_name)
    end
  end

  private

  # Creates a Comparison File from a file name
  def self.read_file(file_name)
    file_contents = File.open(file_name, 'rb') { |file| file.read }
    ComparisonFile.new(file_name, file_contents)
  end

end
