require_relative 'similar_items'

start_time = Time.now

Settings.parse_similarity_arg
Comparator.new(FileReader.read_from_argv)

puts "Time passed: #{Time.now - start_time}"
