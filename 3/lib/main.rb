require_relative 'data_streams'

edges = StreamReader.read_edges_from_argv
Hyperball.new(edges).calculate_hyperballs
