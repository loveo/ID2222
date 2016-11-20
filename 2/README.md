# Frequent itemsets

## Solution

### Counting itemsets

#### Itemsets of size 1
To find singletons the program simply iterates through every basket and increases a counter for each item id.
This is done by letting the item id work as an index to an array of counters.
When the rows are counted, itemsets are filtered out from the counters.

#### Itemsets of any size
Counting itemsets of an arbitrary size is trickier since there are more unique *items* to keep track of.
The solution used in this project is to look at each item id in a basket, find all itemsets that has this item id and check if they exist in this basket.
This was done by creating an array (of itemset arrays) where the index is the item id that row starts with:

```ruby
sets[17] = [(17,55, 102), (17, 99, 722), (17, 505, 987) ... ]
```

This datastructure *roughly* contains 0.1% of the total itemsets being counted which made it easy finding itemsets and increasing their support if needed.

To increase throughput even further, threads were used and rows were calculated concurrently by different workers.
Two small locks were used to achieve this. One on the job queue (bag of row indices) to synchronize work and one mutex lock (synchronization block) when updating the support of an itemset.

### Finding association rules
Once all frequent itemsets are found, rules can be deducted.

This is done by creating all combinations of subsets from each itemset. The rule is then deducted as:
```ruby
subset -> itemset\subset
```

Each rule is then validated by calculating its confidence by looking at the supports of the different itemsets in the rule.
The solution uses the same datastructure as before to quickly find itemsets given item ids.

## How to run
