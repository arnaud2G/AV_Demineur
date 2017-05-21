//
//  Case.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation

struct Case {
    
    enum Statu {
        case mine
        case number
    }
    
    var value = 0
    var statu:Statu
    
    init() {
        self.statu = .number
    }
}
