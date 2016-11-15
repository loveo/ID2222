# Counts the support of given ItemSets
class SetCounter

  FREQUENCY_THRESHOLD = 0.01
  THREAD_SIZE = 8

  def initialize(baskets)
    @baskets    = baskets
    @threshold  = baskets.rows.length * FREQUENCY_THRESHOLD
    @mutex      = Mutex.new
    @jobs       = []
  end

  # Counts an array for item sets by checking each bucket
  def count_item_sets(item_sets)
    @baskets.rows.each do |basket|
      SetCounter.count_all_item_sets_in_basket(basket, item_sets)
    end
  end

  # Returns an array of item sets with high enough support
  def supported_sets(item_sets)
    item_sets.values.flatten.reject do |item_set|
      item_set.support < @threshold
    end
  end

  private

  def threaded_count
    @jobs = (0 .. @baskets.rows.length)

    workers = (0 .. THREAD_SIZE).each.map do 
      Thread.new { threaded_basket_count() }
    end

    workers.each do |thread|
      thread.join
    end
  end

  def threaded_basket_count

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
