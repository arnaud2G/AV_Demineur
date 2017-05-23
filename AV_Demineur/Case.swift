//
//  Case.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

class Case {
    
    enum Statu {
        case mine
        case number
    }
    var statu:Statu
    
    // Bool qui permet de savoir si la case est retournée
    var isTested:Bool = false
    
    // current value permet de faire le décompte des mines autours de la case
    var value:Int = 0
    var currentValue:Int!
    
    init(statu:Statu) {
        self.statu = statu
    }
    
    func testCase(value:Int) {
        isTested = true
        self.value = value
    }
    
    func testMine() -> Bool {
        isTested = true
        return statu == .mine
    }
}

struct CaseView {
    
    let myCase:Case
    
    init(initCase:Case) {
        self.myCase = initCase
    }
    
    func caseText() -> String? {
        if myCase.isTested {
            switch myCase.statu {
            case .mine:
                return "X"
            case .number:
                return "\(myCase.value)"
            }
        } else {
            return nil
        }
    }
    
    func caseColor() -> UIColor {
        if myCase.isTested {
            return .darkGray
        } else {
            return .lightGray
        }
    }
}
