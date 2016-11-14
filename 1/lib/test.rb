require_relative 'similar_items'

files = FileReader.read_from_argv

Comparator.new(files)

byebug

puts ""
