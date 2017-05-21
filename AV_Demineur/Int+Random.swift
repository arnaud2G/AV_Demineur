//
//  Int+Random.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation

public extension Int {
    public static func random (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
