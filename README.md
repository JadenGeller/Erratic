# Erratic

`LazyShuffleCollection` provides a shuffled view into a collection that whose order is lazily determined as indices are accessed. Because of this, it provides a fast way to access and mutate random elements of a collection without determining the shuffling of the entire collection.
```swift
let arr = [1, 2, 3, 4].lazy.shuffe()
print(arr) // -> [2, 3, 1, 4]
arr.shuffle()
print(arr) // -> [3, 4, 1, 2]
```
Note that index access has average case time complexity `O(n)` on first access and worst case time complexity `O(1)` on subsequent access, where `n` is the number of indices already determined. It follows that if `n < N` indices of the collection are access for some constant `N`, we observe average case `O(1)` time complexity on first access.

`LazyShuffleCollection` collection exposes a property `permutation` that represents the current shuffling. Thus, this shuffling can be saved and later restored if desired. `LazyShuffleCollection` also exposes a `base` property to access the unshuffled backing of the collection.
```swift
var foo = [1, 2, 3, 4].lazy.shuffle()
let shuffling = foo.permutation // save for later
foo.shuffle()                   // shuffle
foo.permutation = shuffling     // restore
```

We can also easily unshuffle our collection, or create unshuffled instances of `LazyShuffleCollection`.
```swift
var bar = LazyShuffleCollection(unshuffled: [1, 2, 3, 4])
bar.shuffle()
bar.permutation = .unshuffled
```

Shuffled collections can be mutated in a way that modifies the `base` as well using `MutableLazyShuffleCollection` or `RangeReplaceableLazyShuffleCollection`.
```swift
var bazz = MutableLazyShuffleCollection(unshuffled: [1, 2, 3, 4])
bazz.shuffle()
bazz[0] = 100
// print(bazz.base)
// -> [100, 2, 3, 4] OR [1, 100, 3, 4] OR [1, 2, 100, 4] OR [1, 2, 3, 100]
```

Erratic was built on top of [Permute](https://github.com/JadenGeller/Permute), a Swift module for permuted collection types.
