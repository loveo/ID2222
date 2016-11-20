# Creates sets of different sizes
class SetCreator

  # Returns a hash of doubleton ItemSets from singleton ItemSets
  def self.create_doubletons(singletons)
    item_ids = singletons.map(&:id)
    create_doubletons_from_item_ids(item_ids)
  end
  
  # Creates permutations of possible frequent item sets
  # given item_sets of any size and frequent singletons
  def self.create_permutations(item_sets, singletons)
    item_ids      = singletons.map(&:id)
    permutation_ids = item_sets.map(&:all_item_ids)

    create_permutations_from_item_ids(item_ids, permutation_ids)
  end

  private

  # Creates a hash with item_id as key and an 
  # array of doubleton ItemSets as value
  def self.create_doubletons_from_item_ids(item_ids)
    set_hash = []

    item_ids.each_with_index do |item_id, index|
      set_hash[item_id] = create_doubletons_array(
        item_id,
        item_ids[index + 1 .. -1]
        )
    end

    set_hash
  end

  # Creates tripleton hash from doubletons and singletons
  def self.create_permutations_from_item_ids(item_ids, item_sets)
    set_hash = []
    
    item_ids.each do |item_id|
      set_hash[item_id] = create_permutations_array(
        set_hash,
        item_id,
        item_sets
        )
    end
    
    set_hash
  end

  # Creates an array of permutations of all non-duplicate item sets
  def self.create_permutations_array(set_hash, item_id, item_sets)
    permutations = []

    item_sets.each do |item_set|
      item_ids = [item_id] + item_set

      unless item_set.include?(item_id) || item_set_exists?(set_hash, item_ids)
        permutations << ItemSet.new(item_ids)
      end
    end

    permutations
  end

  # Returns true if this item set already exists
  def self.item_set_exists?(set_hash, item_ids)
    smallest_id = item_ids.min
    row         = set_hash[smallest_id]
    item_ids    = item_ids.sort

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
