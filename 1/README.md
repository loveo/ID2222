# Similar Items

## Solution

### Shingles
Each file is turned into *shingles* by cutting it into small chunks, 
these chunks are then hashed (with 32 bit CRC) to save space and comparison complexity. 
Before cutting any file, its text is turned into lowercase and spaces are replaced with underscores.

### Signature vectors
Each set of shingles (located in a file) is also represented as a shortened version with its most representative shingles.
This is achieved by applying min-hash to the set and picking the smallest value (hashed shingle) many times.
A linear hash function is used (y = kx + b % c) which is unique for each min-hash iteration.

### Locality hashing
In order to filter out candidates and reduce the amount of comparisons needed, locality hashing is used. 
The signature vector of each file is split into bands that are hashed and used for indexing buckets in a hash table.
Files that end up in the same bucket(s) are candidates of being similar and is what comparisons are based upon.

By choosing the amount of bands (and rows per band) one can alter the probability of false-negatives vs false-positives.
This project chose a band size that gave the smallest false-positive probability possible while avoiding false-negatives.
The amount of buckets in the hash table also determines the amount of missed candidates. 
A rather large size was used in this project to increase comparison speed by increasing the chance of false-negatives.

### Finding similar items
Each file is run through the above procedure and then uses the following logic to find similar items:

```ruby
# Compares a given file to its candidates
def compare_file(file)
  candidates = possible_candidates_for(file)
  candidates = SignatureMatrix.filter_candidates(file, candidates)
  file.compare_to_candidates(candidates)
end
```

A file finds its candidates by merging all the buckets it was placed in. 
These bucket ids are saved earlier to avoid recalculating hashes.
The file first removes all candidates that it already knows it is simlar to, by looking in its *similar_files* list.

The file then removes all candidates that are *likely* to be un-similar by comparing its signature vector to the others.
This is done by calculating the fraction of elements that are equal (value and index) and compares it against
the wanted similarity threshold.

The files that remain are compared by using Jaccard similarity, calculating the intersection of shingles divided by the union of shingles.
Files that passes this far are considered similar and are added to the files (and, since comparison is commutative, the similar files) list of similar files.

## How to run


Submission. Your homework solution must include source code if required (with essential comments); 
Makefile or scripts to build and run; a report (in PDF or a plain text file) with a short description
of your solution, instructions how to build and to run, command-line parameters, if any
(including default values), results, e.g., plots or screenshots. 
You upload your solution in a zip file to Bilda. 
To get bonus, you should upload your solution before the deadline. 
Bilda records the submission time. Bonus will not be given, if you miss the deadline.
