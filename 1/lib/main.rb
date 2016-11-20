require_relative 'similar_items'

Settings.parse_similarity_arg
Comparator.new(FileReader.read_from_argv)
