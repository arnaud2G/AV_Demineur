//
//  GamerManager.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation

enum GameLevel {
    case easy, medium, hard
    
    func nCase() -> (nRow:Int,nCol:Int) {
        switch self {
        case .easy:
            return (9,9)
        case .medium:
            return (16,16)
        case .hard:
            return (30,16)
        }
    }
    
    func nBombe() -> Int {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 40
        case .hard:
            return 100
        }
    }
}

class GameManager {
    
    var delegate:GameControllerProtocol?
    
    var timer:Timer?
    var gameTime:Double = 0
    
    var nCaseToReturn:Int = 0 {
        didSet {
            if nCaseToReturn == gameLevel.nCase().nCol*gameLevel.nCase().nRow - gameLevel.nBombe() {
                self.delegate?.winner()
            }
        }
    }
    var gameDistribution = [[Case]]()
    
    // A l'initialisation de la partie, on calcul la position des bombes
    let gameLevel:GameLevel
    init(gameLevel:GameLevel) {
        self.gameLevel = gameLevel
        initGame()
    }
    
    private func initGame() {
        
        self.nCaseToReturn = 0
        
        // On cherche les bombes
        var bombLocation = [Int]()
        var myRandomTable = [Int]()
        myRandomTable += 0..<(gameLevel.nCase().0*gameLevel.nCase().1)
        for _ in 0..<gameLevel.nBombe() {
            let newIndex = myRandomTable[Int.random(lower: 0, upper: myRandomTable.count-1)]
            bombLocation.append(newIndex)
            myRandomTable.remove(at: myRandomTable.index(of: newIndex)!)
        }
        
        // On créé le tableau du jeux
        gameDistribution = (0..<(gameLevel.nCase().nRow*gameLevel.nCase().nCol))
            .map({(i:Int) in
                if bombLocation.index(of: i) == nil {
                    return Case(statu: .number)
                } else {
                    return Case(statu: .mine)
                }
            }).chunks(gameLevel.nCase().nCol)
        
        // Example de test
        print(gameDistribution
            .flatMap{$0}
            .filter{$0.statu == .mine}
            .count)

        print(gameDistribution
            .flatMap{$0}
            .filter{$0.statu == .number}
            .count)
    }
    
    // On lance le timer
    func startGame() {
            timer = Timer.init(timeInterval: 0.01, repeats: true, block: {_ in 
                self.gameTime += 0.01
            })
    }
    
    // MARK: - Action sur une case
    func caseCliqued(indexPath:IndexPath) {
        
        // On test si l'utilisateur se trompe
        if gameDistribution[indexPath.section][indexPath.row].testMine() {
            self.delegate?.returnCase(indexPaths: [indexPath])
            self.delegate?.looser()
            return
        }
        
        // Case à retourner
        var caseToReturn = Array(Set(chainZeroValue(indexPath: indexPath)))
        caseToReturn.append(indexPath)
        
        nCaseToReturn += caseToReturn.count
        
        self.delegate?.returnCase(indexPaths: caseToReturn)
    }
    private func chainZeroValue(indexPath:IndexPath) -> [IndexPath] {
        
        var ret = [IndexPath]()
        
        // On cherche le nombre de mine autour
        let caseArround = getCaseArround(indexPath:indexPath)
        let nMine = caseArround.filter{gameDistribution[$0.section][$0.row].statu == .mine}.count
        
        gameDistribution[indexPath.section][indexPath.row].testCase(value: nMine)
        
        if nMine == 0 {
            
            let untestedCase = caseArround.filter({!gameDistribution[$0.section][$0.row].isTested})
            ret.append(contentsOf: untestedCase)
            
            for aCase in untestedCase { // On filtre pour éviter la redondance mais ce n'est pas suffisant
                ret.append(contentsOf: chainZeroValue(indexPath: aCase))
            }
        }
        
        return ret
    }
    
    // MARK: - Recherche des cases autour
    private func getCaseArround(indexPath:IndexPath) -> [IndexPath] {
        
        var ret = getCaseInRawArround(section:indexPath.section, row:indexPath.row)
        ret += getCaseInRawArround(section:indexPath.section-1, row:indexPath.row)
        ret += getCaseInRawArround(section:indexPath.section+1, row:indexPath.row)
        
        return ret
    }
    
    private func getCaseInRawArround(section:Int, row:Int) -> [IndexPath] {
        if section == -1 || section >= gameLevel.nCase().nRow {return []}
        var ret = [IndexPath(row:row, section:section)]
        if row-1 >= 0 {ret.append(IndexPath(row:row-1, section:section))}
        if row+1 < gameLevel.nCase().nCol {ret.append(IndexPath(row:row+1, section:section))}
        return ret
    }
}


