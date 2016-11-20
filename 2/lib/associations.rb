# Finds associtations between frequent itemsets
class Associations

  def initialize(item_set_arrays)
    @structure = nil

    create_structure(item_set_arrays)
  end

  # Creates all confident assocation rules
  def create_association_rules
    filter_rules(find_rules)
  end

  # Finds an item set given an array of item ids
  def find_item_set(item_ids)
    sets_array = @structure[item_ids.length]
    sub_items = item_ids.map { |id| sets_array[id] }.compact.flatten

    array_index = sub_items.index do |item_set| 
      item_set.same_ids?(item_ids) 
    end

    sub_items[array_index]
  end

  private

  # Finds rules from size 2 and up
  def find_rules
    (2 .. @structure.length - 1).map do |set_size|
      create_associations_for_set_size(set_size)
    end
    .flatten
  end

  # Filters out rules with too small confidence
  def filter_rules(rules)
    rules.reject do |rule|
      rule.confidence < Settings::CONFIG.confidence_threshold
    end
  end

  # Creates rules for a specific set size
  def create_associations_for_set_size(set_size)
    @structure[set_size].compact.flatten.map do |item_set|
      create_rules(item_set.all_item_ids)
    end
  end

  # Creates rules from a list of item sets
  def create_rules(item_ids)
    (1 .. item_ids.length - 1).map do |set_size|
      create_combination_rules(item_ids, set_size)
    end
    .flatten
  end

  # Creates rules for a given combination size
  def create_combination_rules(item_ids, set_size)
    item_ids.combination(set_size).map do |combination|
      Rule.new(combination, item_ids - combination, self)
    end
  end

  # Creates a structure of item sets, to easily find item sets given item ids
  def create_structure(item_set_arrays)
    @structure = []

    item_set_arrays.each_with_index do |item_sets, index|
      @structure[index + 1] = create_sub_structure(item_sets)
    end
  end

  # Creates the inner array for an item set
  def create_sub_structure(item_sets)
    item_set_array = []

    item_sets.each do |item_set|
      add_item_to_array(item_set_array, item_set)
    end

    item_set_array
  end

  # Adds an item set to an array, or creates one if needed
  def add_item_to_array(array, item_set)
    item_id = item_set.id

    unless array[item_id]
      array[item_id] = [item_set]
    else
      array[item_id] << item_set
    end
  end

  # Wrapper class for an association rule
  class Rule

    attr_reader :confidence

    def initialize(from_ids, to_ids, parent)
      @from_set   = parent.find_item_set(from_ids)
      @to_set     = parent.find_item_set(to_ids)
      @big_set    = parent.find_item_set( (from_ids + to_ids) )

      calculate_confidence
    end

    # String representation of a Rule
    def to_s
      "#{@from_set.all_item_ids} -> #{@to_set.all_item_ids} " +
      "with #{@confidence} confidence"
    end

    private

    # Calculates the confidence for this rule
    def calculate_confidence
      @confidence = @big_set.support.to_f / @from_set.support.to_f
    end

  end

end
