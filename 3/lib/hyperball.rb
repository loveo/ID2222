
class Hyperball

	POOL_SIZE = 8

	def initialize(edges)
		@counters = Counters.new
		@edges    = edges
	end

	#Runs one pass of hyperball
	def hyperball_once
		create_workers.each(&:join)

		puts "changes: #{@counters.get_changed_counters.size}"

		if @counters.any_changes?
			@counters.apply_changes
			true
		else
			false
		end
	end

	def hyperball_on_edge(edge)
		update_node 	= @counters.get_counter(edge[1])
		neighbor_node = @counters.get_counter(edge[0])

		update_node.merge(neighbor_node)
	end

	# Creates a queue with one entry per edge pair
	def create_work_queue
		queue = Queue.new

		@edges.size.times do |index|
			queue << index
		end

		queue
	end

	# Returns workers prepped with work queues
	def create_workers
		job_queue = create_work_queue

		POOL_SIZE.times.map do
			Thread.new { worker_method(job_queue) }
		end
	end

	def worker_method(job_queue)
		begin
			while edge_index = job_queue.pop(true)
				hyperball_on_edge(@edges[edge_index])
			end
		rescue ThreadError
		end
	end

	def calculate_hyperballs
		while hyperball_once
		end

		binding.pry
	end

end