# Read files from arguments
class FileReader

  def self.read_from_argv
    read_files(ARGV)
  end

  def self.read_files(file_names)
    file_names.map do |file_name|
      read_file(file_name)
    end
  end

  private

  def self.read_file(file_name)
    file_contents = File.open(file_name, 'rb') { |file| file.read }
    ComparisonFile.new(file_name, file_contents)
  end

end
