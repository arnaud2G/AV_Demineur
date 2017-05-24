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
    
    // Le flag correspond au statu donné par l'utilisateur
    enum Flag {
        case interrogation
        case mine
        case value
        case none
    }
    var flag:Flag = .none
    
    // Le statu correspond au statu donné par l'ordinateur et initialisé au début de la partie
    enum Statu {
        case mine
        case number
    }
    var statu:Statu
    
    // Bool qui permet de savoir si la case est retournée
    //var isTested:Bool = false
    
    // Nombre de mine autour de la case
    var value:Int = 0
    
    init(statu:Statu) {
        self.statu = statu
    }
    
    // On attribu le nombre de mine autour de la case
    func testCase(value:Int) {
        flag = .value
        self.value = value
    }
    
    // On test s'il s'agit d'une mine
    func testMine() -> Bool {
        flag = .value
        return statu == .mine
    }
    
    // On change le flag
    func putFlag() {
        switch flag {
        case .none:
            flag = .mine
        case .mine:
            flag = .interrogation
        case .interrogation:
            flag = .none
        case .value:
            return
        }
    }
    func resetFlag() {
        switch flag {
        case .value:
            return
        default:
            flag = .none
        }
    }
}

struct CaseView {
    
    static let tColor:[UIColor] = [.black, .blue, .red, .green, .purple, .brown, .cyan, .orange, .white]
    
    let myCase:Case
    
    init(initCase:Case) {
        self.myCase = initCase
    }
    
    func caseText() -> String? {
        switch myCase.flag {
        case .none:
            return nil
        case .interrogation:
            return "?"
        case .mine:
            return "💣"
        case .value:
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
        }
    }
    
    func caseColor() -> UIColor {
        switch myCase.flag {
        case .value, .mine, .interrogation:
            return .lightGray
        case .none:
            return .darkGray
        }
    }
    
    func textColor() -> UIColor {
        switch myCase.flag {
        case .value:
            return CaseView.tColor[myCase.value]
        default:
            return .black
        }
    }
}
