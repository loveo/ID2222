# Represents an item set of any size
class ItemSet

  attr_reader :item_ids
  attr_reader :id, :support

  def initialize(ids)
    @id       = ids[0]
    @item_ids = ids[1 .. -1]
    @support  = 0
    @mutex = Mutex.new
  end

  # Checks this item set against a basket 
  # and increases its support if it is present
  def check_basket(basket)
    increase_support if in_basket?(basket)
  end
  
  def all_item_ids
	[id] + item_ids
  end

  private

  # Returns true if this item sets remaining items occurs in a given basket
  def in_basket?(basket)
    @item_ids.all? do |item_id|
      basket.include?(item_id)
    end
  end

  # Increases the support for this item set
  def increase_support
    @mutex.synchronize do 
      @support += 1
    end
  end

end
