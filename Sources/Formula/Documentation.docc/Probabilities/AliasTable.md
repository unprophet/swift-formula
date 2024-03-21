# ``AliasTable``

## Overview

An alias method is an efficient algorithm for sampling integers from a discrete probability distribution in _O_(1) time, with an initial setup cost of _O_(_n_).
This implementation uses Vose's algorithm to solve for errors created by floating-point numerical instability, and generates integers in the range 0 ≤ _i_ < _n_, where _n_ is the number of weights in an array describing some distribution.

> Note: For an excellent write-up on how the algorithm works, where it comes from, and what makes it so efficient, check out the article [Darts, Dice, and Coins](https://www.keithschwarz.com/darts-dice-coins/) by Keith Schwarz.

### Process

The algorithm starts with a list of weights. Conceptually, each weight represents a face of an _n_-sided die (where _n_ is the total number of weights), and the value of a weight represents the probability of rolling that face.

For example, the weights ( ⅙, ⅙, ⅙, ⅙, ⅙, ⅙ ) represent a fair six-sided die, and the weights ( ⅕, ⅕, ⅕, 0, ⅕, ⅕ ) represent a loaded die which never rolls a 4.

In code, that looks like:

```swift
let weights = [0.2, 0.2, 0.2, 0.0, 0.2, 0.2]
let table = AliasTable(from: weights)

let sample = table.sample // can be 0, 1, 2, 4, or 5, but never 3
```

The algorithm uses the weights to generate two tables, a _probability_ table and an _alias_ table, which it in turn uses to generate random samples.
Abstractly, the probability table represents a collection of biased coins.
To generate a sample, the algorithm first rolls a fair die to select a coin, and then flips that coin to decide between keeping the value of the die roll, or using the alias value.

## Topics

### Creating Tables

- ``AliasTable/init(from:)``

### Sampling

- ``AliasTable/sample``
- ``AliasTable/sample(count:)``
- ``AliasTable/sample(using:)``
