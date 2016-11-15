# Represents all baskets
class Baskets

  attr_reader :rows

  def initialize(file)
    @rows = []
    parse_file(file)
  end

  private

  # Parses the whole file, turning it into sets of item ids
  def parse_file(file)
    File.readlines(file).each do |line|
      parse_line(line)
    end
  end

  # Parses one line, turning it into a set if item ids
  def parse_line(line)
    row_set = Set.new

    line.split(' ').each do |item_id|
      row_set.add(item_id.to_i)
    end

    rows << row_set
  end

end
