# Counts the support of given ItemSets
class SetCounter

  def initialize(baskets)
    @baskets   = baskets
    @threshold = baskets.rows.length * Settings::CONFIG.support_threshold
    @job_queue = Queue.new
  end

  # Counts an array for item sets by checking each bucket
  def count_item_sets(item_sets)
    threaded_count(item_sets)
  end

  # Returns an array of item sets with high enough support
  def supported_sets(item_sets)
    item_sets.flatten.compact.reject do |item_set|
      item_set.support < @threshold
    end
  end

  private

  # Creates threads that counts item sets in baskets
  # and waits for them to finish
  def threaded_count(item_sets)
    create_job_queue

    create_workers(item_sets).each(&:join)
  end

  # Puts each basket on the job queue
  def create_job_queue
    (0 .. @baskets.rows.length - 1).each do |row_index|
      @job_queue << row_index
    end
  end

  # Creates worker threads and tells them to count baskets
  def create_workers(item_sets)
    (0 .. Settings::CONFIG.pool_size - 1).map do 
      Thread.new { threaded_basket_count(item_sets) }
    end
  end

  # Worker method that takes baskets from a job queue and counts them
  def threaded_basket_count(item_sets)
    while not @job_queue.empty?
      row_index = @job_queue.pop

      SetCounter.count_all_item_sets_in_basket(
        @baskets.rows[row_index],
        item_sets
        )

      Thread.exit if @job_queue.empty?
    end
  end

  # Counts the support of all item sets in a given basket
  def self.count_all_item_sets_in_basket(basket, item_sets)
    basket.each do |item_id|
      SetCounter.count_sub_item_sets_in_basket(basket, item_sets[item_id])
    end
  end

  # Counts the support of item sets starting with a specific item_id in a basket
  def self.count_sub_item_sets_in_basket(basket, item_sets)
    if item_sets
      item_sets.each do |item_set|
        item_set.check_basket(basket)
      end
    end
  end

end
