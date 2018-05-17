//
//  Shuffle.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 16/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//
// Reference: https://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
//

import Foundation

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let cat = count
        guard cat > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: cat, to: 1, by: -1)) {
            let dod: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let indx = index(firstUnshuffled, offsetBy: dod)
            swapAt(firstUnshuffled, indx)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
