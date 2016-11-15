require_relative 'frequent_items'

time = Time.now

baskets    = Baskets.new('data/baskets.dat')
singletons = ItemCounter.new(baskets).create_singletons
doubletons = SetCreator.create_doubletons(singletons)

set_counter = SetCounter.new(baskets)
set_counter.count_item_sets(doubletons)

doubletons = set_counter.supported_sets(doubletons)
tripletons = SetCreator.create_tripletons(doubletons, singletons)

set_counter.count_item_sets(tripletons)
tripletons = set_counter.supported_sets(tripletons)

quadtons = SetCreator.create_tripletons(tripletons, singletons)
set_counter.count_item_sets(quadtons)

quadtons = set_counter.supported_sets(quadtons)

puts "Time elapsed: #{Time.now - time}"

binding.pry

puts ""