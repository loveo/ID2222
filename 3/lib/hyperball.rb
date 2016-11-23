
class Hyperball
	
	def initialize(counters)
		@counters = counters
	end
	
	
	#Runs one pass of hyperball
	def hyperball(edges)
		edges.each do |edge|
			update_node = @counters(edge[1])
			neighbor_node = @counters(edge[0])
			update_node.merge(neighbor_node)
		end
			@counters.apply_changes
	end
	
end