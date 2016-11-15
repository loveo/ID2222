# Creates sets of different sizes
class SetCreator

  # Returns a hash of doubleton ItemSets from singleton ItemSets
  def self.create_doubletons(singletons)
    item_ids = singletons.map(&:id)
    create_doubletons_from_item_ids(item_ids)
  end
  
  def self.create_tripletons(doubletons, singletons)
    item_ids      = singletons.map(&:id)
    doubleton_ids = doubletons.map(&:all_item_ids)

    create_tripletons_from_item_ids(item_ids, doubleton_ids)
  end

  private

  # Creates a hash with item_id as key and an 
  # array of doubleton ItemSets as value
  def self.create_doubletons_from_item_ids(item_ids)
    set_hash = {}

    item_ids.each_with_index do |item_id, index|
      set_hash[item_id] = create_doubletons_array(
        item_id,
        item_ids[index + 1 .. -1]
        )
    end

    set_hash
  end

  # Creates tripleton hash from doubletons and singletons
  def self.create_tripletons_from_item_ids(item_ids, doubletons)
    set_hash = {}
    
    item_ids.each do |item_id|
      set_hash[item_id] = create_tripletons_array(
        set_hash,
        item_id,
        doubletons
        )
    end
    
    set_hash
  end

  # Creates an array of tripletons of all non-duplicate item sets
  def self.create_tripletons_array(set_hash, item_id, doubletons)
    tripletons = []

    doubletons.each do |doubleton|
      item_ids = [item_id] + doubleton

      unless doubleton.include?(item_id) || item_set_exists?(set_hash, item_ids)
       tripletons << ItemSet.new(item_ids)
      end
    end

    tripletons
  end

  # Returns true if this item set already exists
  def self.item_set_exists?(set_hash, item_ids)
    smallest_id = item_ids.min
    row = set_hash[smallest_id]
    item_ids = item_ids.sort

    if row
      row.any? do |item_set|
        item_set.include_ids?(item_ids)
      end
    else
      false
    end
  end

  # Creates an array of doubleton ItemSets
  def self.create_doubletons_array(item_id, sub_indices)
    sub_indices.map do |sub_index|
      ItemSet.new([item_id, sub_index])
    end
  end
  
end
