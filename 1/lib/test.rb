require_relative 'similar_items'

files = FileReader.read_from_argv

comparator = Comparator.new(files)

files.each do |file|
  file.print_similarities
end

byebug

puts ""
