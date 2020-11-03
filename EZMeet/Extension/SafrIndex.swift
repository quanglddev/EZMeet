//
//  SafrIndex.swift
//  EZMeet
//
//  Created by QUANG on 10/1/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
