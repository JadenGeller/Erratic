# Erratic

`LazyShuffleCollection` provides a shuffled view into a collection that whose order is lazily determined as indices are accessed. Because of this, it provides a fast way to access and mutate random elements of a collection without determining the shuffling of the entire collection.
```swift
let arr = [1, 2, 3, 4].lazy.shuffe()
print(arr) // -> [2, 3, 1, 4]
arr.shuffle()
print(arr) // -> [3, 4, 1, 2]
```
Note that index access has average case time complexity `O(n)` on first access and worst case time complexity `O(1)` on subsequent access, where `n` is the number of indices already determined. It follows that if `n < N` indices of the collection are access for some constant `N`, we observe average case `O(1)` time complexity on first access.

`LazyShuffleCollection` collection exposes a property `permutation` that represents the current shuffling. Thus, this shuffling can be saved and later restored if desired.
```swift
var bleh = MutableLazyShuffleCollection(unshuffled: [1, 2, 3, 4])
let unshuffledPermutation = bleh.permutation
bleh.shuffle()
bleh[0] = 100
bleh.permutation = unshuffledPermutation
print(bleh) // -> [1, 4, 100, 3]
```
