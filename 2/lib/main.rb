require_relative 'frequent_items'

Settings.read_arguments
Finder.new( Baskets.new('data/baskets.dat') )
