# Creates sets of different sizes
class SetCreator

  # Returns a hash of doubleton ItemSets from singleton ItemSets
  def self.create_doubletons(singletons)
    item_ids = singletons.map(&:id)
    SetCreator.create_doubletons_from_item_ids(item_ids)
  end

  private

  # Creates a hash with item_id as key and an 
  # array of doubleton ItemSets as value
  def self.create_doubletons_from_item_ids(item_ids)
    set_hash = {}

    item_ids.each_with_index do |item_id, index|
      set_hash[item_id] = SetCreator.create_doubletons_array(
        item_id,
        item_ids[index + 1 .. -1]
        )
    end

    set_hash
  end

  # Creates an array of doubleton ItemSets
  def self.create_doubletons_array(item_id, sub_indices)
    sub_indices.map do |sub_index|
      ItemSet.new([item_id, sub_index])
    end
  end

end
