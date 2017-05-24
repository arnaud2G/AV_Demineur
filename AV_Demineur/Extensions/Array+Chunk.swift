//
//  Array+Chunk.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 23/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
