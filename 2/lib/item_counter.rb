# Counts how many times each item exists in a basket and creates singletons
class ItemCounter

  FREQUENCY_THRESHOLD = 0.01

  def initialize(baskets)
    @item_counts = []
    @baskets     = baskets
  end

  # Returns a list frequent singletons
  def create_singletons
    count_items
    create_item_sets
  end

  private

  # Counts the support for each singleton
  def count_items
    @baskets.rows.each do |basket|
      count_basket(basket)
    end
  end

  # Counts the support in one row
  def count_basket(basket)
    basket.each do |item_id|
      increase_item_count(item_id)
    end
  end

  # Returns all singletons that has high enough support
  def create_item_sets
    threshold  = @baskets.rows.length * FREQUENCY_THRESHOLD
    singletons = []

    @item_counts.each_with_index do |support, item_id|
      singletons << ItemSet.new([item_id]) if support && support >= threshold
    end

    singletons
  end

  # Increases the support for one item id 
  def increase_item_count(index)
    current_value = @item_counts[index] ||= 0

    @item_counts[index] = current_value + 1
  end

end
