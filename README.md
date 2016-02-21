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

## Time Complexity

We will examine how Erratic accomplishes lazy shuffling to determine the time complexity of the process. Erratic is built on top of [Permute](https://github.com/JadenGeller/Permute), a Swift module for permuted collection types. Effectively, Erratic simply generates a `LazyShufflePermutation` that lazily maps unshuffled indices to shuffled indices. Let's look at how this is accomplished!

`LazyShufflePermutation` utilizes a `UniqueRandomGenerator` that will generate random members of a collection but never repeating a given member. This is accomplished by keeping a set of indices whose element we've already generated. When we generate a new random index, we check if it is in the set. If so, we generate a new element; if not, we add it and then return the element. Obviously this implies that the 0th unique access will be in consant time, and each subsequent access will take longer and longer. Also notice that, the larger the array, the more quickly we'll be able to make subsequent unique accesses since it'll less likely be an already chosen element. Once we've already determined the element at a given index, we will be able to reaccess it in constant time.

Denoting `n` to be the number of elements in the array and denoting `x` to be the number of unique index accesses made so far, we should expect another unique access to take `O(x/(n - x))` time. This result can be obtained by treating each access attempt as a Bernoulli trial.

Note that shuffling has `O(1)` time complexity since the shuffle is completed lazily.
