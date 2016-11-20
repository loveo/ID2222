# Finds frequent item sets and confident association rules
class Finder

  def initialize(baskets)
    @baskets   = baskets
    @item_sets = []
    @rules     = []

    find_sets_and_rules

    print_item_sets
    print_rules
  end

  private

  # Finds all frequent item sets and rules
  def find_sets_and_rules
    @item_sets << find_singletons
    find_frequent_item_sets
    @rules = find_rules
  end

  # Finds item sets until no item sets of a size is found
  def find_frequent_item_sets
    set_counter = SetCounter.new(@baskets)
    
    while true
      item_sets = get_supported_item_sets(set_counter)

      if item_sets.empty?
        break
      else
        @item_sets << item_sets
      end
    end
  end

  # Finds rules given item sets
  def find_rules
    Associations.new(@item_sets).create_association_rules
  end

  # Returns the supported item sets for the 'next' item set size 
  def get_supported_item_sets(set_counter)
    permutations = create_permutations

    set_counter.count_item_sets(permutations)
    set_counter.supported_sets(permutations)
  end

  # Creates the next item set permutations
  def create_permutations
    if @item_sets.length == 1
      SetCreator.create_doubletons(@item_sets.first)
    else
      SetCreator.create_permutations(@item_sets[-1], @item_sets.first)
    end
  end

  # Uses ItemCounter to find singletons
  def find_singletons
    ItemCounter.new(@baskets).create_singletons
  end

  # Prints frequent item sets
  def print_item_sets
    puts "Item Sets"

    @item_sets.flatten.each { |item_set| puts "#{item_set}" }
  end

  # Print confident association rules
  def print_rules
    puts "Rules"

    @rules.each { |rule| puts "#{rule}" }
  end

end
