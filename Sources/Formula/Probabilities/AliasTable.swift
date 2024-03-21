//---------------------------------------
// formula: [[ AliasTable ]]
//
// copyright 2024 unprophet
// licensed under the apache license v2.0
//---------------------------------------

/// Simulates random sampling from a discrete probability distribution, such as rolling a loaded die.
public struct AliasTable {
    let probabilities: [Double]
    let aliases: [Int]
    
    /// Samples a random integer from the stored probability distribution.
    ///
    /// Abstractly, the stored probability table represents a collection of biased coins.
    /// To generate a sample, the algorithm first rolls a fair die to select a coin, and then flips that coin to decide between keeping the value of the die roll, or using the alias value.
    public var sample: Int {
        let i = Int.random(in: 0 ..< self.probabilities.endIndex) // this is the die roll
        let k = Double.random(in: 0..<1) < self.probabilities[i] // this is the coin flip
        
        return k ? i : self.aliases[i]
    }
    
    /// Creates a new AliasTable from an array of weights describing some probability distribution.
    ///
    /// Conceptually, each weight represents a face of an _n_-sided die (where _n_ is the total number of weights), and the value of a weight represents the probability of rolling that face.
    ///
    /// - Parameter weights: An array of values describing some probability distribution.
    public init(from weights: [Double]) {
        // ensure weights are normalized between 0.0 and 1.0
        let w: [Double]
        let sum = weights.reduce(0, +)
        w = sum == 1 ? weights : weights.map { $0 / sum }
        
        // rescale weights around average probability
        var p = w.map { $0 * Double(w.count) }
        
        // initialize tables
        var probabilities = Array(repeating: 0.0, count: p.count)
        var aliases = Array(repeating: 0, count: p.count)
        
        // initialize index categories
        var small: [Int] = []
        var large: [Int] = []
        
        // categorize indexes by probability size
        for (i, size) in p.enumerated() { if size < 1 { small.append(i) } else { large.append(i) } }
        
        // fill tables by traversing categorized indexes and equalizing probabilities
        while !small.isEmpty && !large.isEmpty {
            let s = small.removeLast() // get most recent small index
            let l = large.removeLast() // get most recent large index
            
            probabilities[s] = p[s] // copy probability at small index
            aliases[s] = l // set alias to large index
            p[l] += p[s] - 1 // reduce probability at large index by amount needed to raise small probability to 1.0
            
            if p[l] < 1 { small.append(l) } else { large.append(l) } // recategorize large index according to new probability
        }
        
        // no more remaining small probabilities, so any remaining large probabilities must already equal 1.0
        while !large.isEmpty {
            let l = large.removeLast()
            probabilities[l] = 1
        }
        
        // ideally if there are no more large probabilities, then the algorithm is complete and both tables are filled
        // however, rounding errors are something that unfortunately exist, so this isn't always true
        // therefore, this only triggers if floating-point chooses violence
        while !small.isEmpty {
            let s = small.removeLast()
            probabilities[s] = 1
        }
        
        // no more indexes left to traverse, so the tables are complete and ready for sampling!
        self.probabilities = probabilities
        self.aliases = aliases
    }
    
    /// Manually samples a single integer using a given list of weights.
    ///
    /// > Important: This is functionally equivalent to the ``AliasTable/sample`` property in an ``AliasTable``, and is suitable only in cases where the value of a single sample is needed and the underlying probability distribution does _not_ need to be stored for later use.
    /// If multiple samples are needed, create an ``AliasTable`` instead.
    ///
    /// - Returns: A single integer randomly sampled using the given list of weights.
    public static func sample(using weights: [Double]) -> Int { AliasTable(from: weights).sample }
    
    /// Returns an array of randomly sampled integers from the stored probability distribution.
    /// - Parameter count: The number of samples to take.
    /// - Returns: An array of size `count` of integers randomly sampled from the stored probability distribution.
    public func sample(count: Int) -> [Int] {
        var samples: [Int] = []
        
        for _ in 0 ..< count { samples.append(self.sample) }
        
        return samples
    }
}

let samples = AliasTable(from: []).sample(count: 26)
