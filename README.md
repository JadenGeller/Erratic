# Erratic

Erratic defines a few types for working with randomized content. `LazyShuffleCollection` provides a shuffled view into a collection that whose order is lazily determined as indices are accessed. Because of this, it provides a fast way to access and mutate random elements of a collection without determining the shuffling of the entire collection. Note that the time complexity of index access has an average case O(n) when all indices in the array are accessed.
```swift
let arr = LazyShuffleCollection([1, 2, 3, 4])
print(arr) // -> [2, 3, 1, 4]
arr.shuffle()
print(arr) // -> [3, 4, 1, 2]
```
Note that the collection exposes a property `permutation` that represents the current shuffling. Thus, this shuffling can be saved and later restored if desired.
```swift
var bleh = MutableLazyShuffleCollection(unshuffled: [1, 2, 3, 4])
let unshuffledPermutation = bleh.permutation
bleh.shuffle()
bleh[0] = 100
bleh.permutation = unshuffledPermutation
print(bleh) // -> [1, 4, 100, 3]
```

Erratic also defines generator types `RepeatingRandomGenerator` and `UniqueRandomGenerator` that, given a collection, will generate random elements. The former, `RepeatingRandomGenerator`, will continue to generate elements forever repeating already generated elements. It also provides no guarentee that every element will be generated before a repeat appears. The latter, `UniqueRandomGenerator`, will generate every element from its collection once and then stop.
