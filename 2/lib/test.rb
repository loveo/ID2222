require_relative 'frequent_items'

baskets    = Baskets.new('data/baskets.dat')
singletons = ItemCounter.new(baskets).create_singletons
doubletons = SetCreator.create_doubletons(singletons)

set_counter = SetCounter.new(baskets)
set_counter.count_item_sets(doubletons)

doubletons = set_counter.supported_sets(doubletons)

byebug

puts ""