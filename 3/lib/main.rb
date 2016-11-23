require_relative 'data_streams'

edges = StreamReader.read_edges_from_argv

hyperball = Hyperball.new(edges)

hyperball.calculate_hyperballs
