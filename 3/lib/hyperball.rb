# Implementation of hyperball algorithm
class Hyperball

  POOL_SIZE = Settings::CONFIG.pool_size

  def initialize(edges)
    @counters  = Counters.new
    @ball_size = 1
    @edges     = edges
  end

  # Runs the hyperball algorithm until convergence
  def calculate_hyperballs
    while hyperball_once
      @ball_size += 1
    end

    print_centralities
  end

  private

  # Runs one pass of hyperball
  def hyperball_once
    create_workers.each(&:join)

    if @counters.any_changes?
      @counters.apply_changes(@ball_size)
      true
    else
      false
    end
  end

  # Runs hyperball algorithm on an edge pair
  def hyperball_on_edge(edge)
    update_node   = @counters.get_counter(edge[1])
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

  # Method for hyperball worker
  def worker_method(job_queue)
    begin
      while edge_index = job_queue.pop(true)
        hyperball_on_edge(@edges[edge_index])
      end
    rescue ThreadError
    end
  end

  # Prints the found centralities with their frequency
  def print_centralities
    values = @counters.all_counters
              .map(&:centrality)
              .map(&:to_i)
              .inject(Hash.new(0)) { |hash, value| hash[value] += 1 ; hash }

    values.each do |value|
      puts value.join(',')
    end
  end

end
