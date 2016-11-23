# Turns a file of egdes into an array
class StreamReader

  # Reads the file from arg
  def self.read_edges_from_argv
    read_file(ARGV.first)
  end

  private

  # Returns the edges from a given file
  def self.read_file(file)
    File.readlines(file).map do |line|
      parse_line(line)
    end
  end

  # Turns each line into [vertex_id, vertex_id]
  def self.parse_line(line)
    line.split(' ').map(&:to_i).first(2)
  end

end
