# HyperBall
*A small program that esimates the centrality of nodes in a graph*

## Solution
*The solution is split into its most relevant parts*

### Flajolet-Martin
Flajolet-Martin counters are used to estimate the number distinct item for in example a stream when it is not possible to count all items.
This application uses FM counters to estimate the number of nodes that can co-reach a certain node in the graph.

A counter is updated by the following procedure:
An item (node) is hashed into a hash-value, this application uses Jenkins hash function on the node id. This hash value is then inspected and split into two parts.
One part is used for deciding which *register* to update and the other part is used to estimate the number of distinct items using trailing (or leading) zeros as a measure.

Here is an example using 16 registers (4 register bits):

```ruby
# Hash value 68 represented as a bit string
000000000100 0101
```

The rightmost 4 bits are converted to a value and used to index a register, 5 in this case.
The remaining leftmost bits are used to count trailing zeros, 2 in this case, which is stored in to register nr 5 increased by 1.


Using more *registers* will lead to a more accurate estimatation at the cost of memory usage. Each register is initialized to `-inf` which indicates that a counter is *incomplete* or haven't seen enough distinct items.
The size of the counter can be estimated as the **number of register over the sum of 2 to the power each register value** multiplied by some adjusting constants. This sum becomes 0 if any register value is `-inf`.
### HyperBall algorithm


## Questions

## How to run
