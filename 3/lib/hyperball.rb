
class Hyperball
	
	def initialize(counters)
		@counters = counters
	end
	
	
	#Runs one pass of hyperball	
	def hyperball_once(edges)
		edges.each do |edge|
			update_node = @counters(edge[1])
			neighbor_node = @counters(edge[0])
			update_node.merge(neighbor_node)
		end
		@counters.apply_changes
		edges
	end
	
	def hyperball(edges)
		while @counters.any_changes? do
			hyperball_once(edges)
		end
	end
	
end