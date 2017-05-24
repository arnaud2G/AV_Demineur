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
    
    enum Flag {
        case interrogation
        case mine
        case none
    }
    var flag:Flag = .none
    
    enum Statu {
        case mine
        case number
    }
    var statu:Statu
    
    // Bool qui permet de savoir si la case est retournée
    var isTested:Bool = false
    
    // Nombre de mine autour de la case
    var value:Int = 0
    
    init(statu:Statu) {
        self.statu = statu
    }
    
    // On attribu le nombre de mine autour de la case
    func testCase(value:Int) {
        isTested = true
        self.value = value
    }
    
    // On test s'il s'agit d'une mine
    func testMine() -> Bool {
        isTested = true
        return statu == .mine
    }
    
    // On change le flag
    func putFlag() {
        if isTested {return}
        switch flag {
        case .none:
            flag = .mine
        case .mine:
            flag = .interrogation
        case .interrogation:
            flag = .none
        }
    }
    func resetFlag() {
        if isTested {return}
        flag = .none
    }
}

struct CaseView {
    
    static let tColor:[UIColor] = [.black, .blue, .red, .green, .purple, .brown, .cyan, .orange, .white]
    
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
                if myCase.value == 0 {
                    return nil
                } else {
                    return "\(myCase.value)"
                }
            }
        } else {
            switch myCase.flag {
            case .none:
                return nil
            case .interrogation:
                return "?"
            case .mine:
                return "💣"
            }
        }
    }
    
    func caseColor() -> UIColor {
        if myCase.isTested || myCase.flag != .none {
            return .lightGray
        } else {
            return .darkGray
        }
    }
    
    func textColor() -> UIColor {
        if myCase.isTested || myCase.flag != .none {
            return CaseView.tColor[myCase.value]
        } else {
            return .black
        }
    }
}