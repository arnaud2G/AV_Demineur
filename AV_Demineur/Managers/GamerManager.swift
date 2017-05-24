//
//  GamerManager.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

enum GameLevel {
    case easy, medium, hard
    
    func nCase() -> (nRow:Int,nCol:Int) {
        switch self {
        case .easy:
            return (9,9)
        case .medium:
            return (16,16)
        case .hard:
            return (16,30)
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
    
    func sizeCase(inCollectionView collectionView:UICollectionView) -> CGSize {
        switch self {
        case .easy:
            let size:CGFloat = (collectionView.frame.size.width)/CGFloat(self.nCase().nCol)
            return CGSize(width: size, height: size)
        case .medium, .hard:
            let size:CGFloat = (collectionView.frame.size.height)/CGFloat(self.nCase().nRow)
            return CGSize(width: size, height: size)
        }
    }
}

class GameManager {
    
    enum GameStatu {
        case off, on, ended
    }
    
    weak var delegate:GameControllerProtocol?
    
    var gameStatu:GameStatu = .off
    var timer:Timer?
    var gameTime:Double = 0 {
        didSet {
            self.delegate?.upChrono(time: gameTime)
        }
    }
    
    var nCaseToReturn:Int = 0 {
        didSet {
            if nCaseToReturn == gameLevel.nCase().nCol*gameLevel.nCase().nRow - gameLevel.nBombe() {
                timer?.invalidate()
                self.winAGame()
            }
        }
    }
    var gameDistribution = [[Case]]()
    
    // A l'initialisation de la partie, on calcul la position des bombes
    let gameLevel:GameLevel
    init(gameLevel:GameLevel) {
        self.gameLevel = gameLevel
    }
    
    func initGame() {
        
        initParam()
        initDistribution()
        
        // On retourne la partie
        self.delegate?.flagMine(nMine: gameLevel.nBombe())
        self.delegate?.startNewGame(gameDistributionView:
            gameDistribution.map({
                (cases:[Case]) -> [CaseView] in
                let casesView:[CaseView] = cases.map({
                    (aCase:Case) -> CaseView in
                    return CaseView(initCase: aCase)
                })
                return casesView
            }))
    }
    func initParam() {
        
        self.nCaseToReturn = 0
        self.gameTime = 0.0
        self.gameStatu = .off
        self.timer?.invalidate()
        self.timer = nil
    }
    func initDistribution() {
        
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            timer in
            self.gameTime += timer.timeInterval
        })
    }
    private func winAGame() {
        gameStatu = .ended
        self.delegate?.winner()
    }
    private func looseAGame() {
        gameStatu = .ended
        self.delegate?.looser()
    }
    
    // MARK: - Action sur une case : simple clique
    func caseCliqued(indexPath:IndexPath) {
        switch gameStatu {
        case .off:
            gameStatu = .on
            startGame()
            testCase(indexPath: indexPath)
        case .on:
            testCase(indexPath: indexPath)
        case .ended:
            return
        }
    }
    
    private func testCase(indexPath:IndexPath) {
        
        // On traite le cas ou la case porte un flag
        if gameDistribution[indexPath.section][indexPath.row].flag != .none {
            gameDistribution[indexPath.section][indexPath.row].putFlag()
            self.delegate?.returnCase(indexPaths: [indexPath])
            self.delegate?.flagMine(nMine: gameLevel.nBombe() - gameDistribution.flatMap{$0}.filter{$0.flag == .mine}.count)
            return
        }
        
        // On test si l'utilisateur se trompe
        if gameDistribution[indexPath.section][indexPath.row].testMine() {
            timer?.invalidate()
            self.delegate?.returnCase(indexPaths: [indexPath])
            looseAGame()
            return
        }
        
        // Case à retourner
        var caseToReturn = Array(Set(chainZeroValue(indexPath: indexPath)))
        caseToReturn.append(indexPath)
        
        // On incrémente le compteur utilisateur
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
    
    // MARK: - Action sur une case : double clique
    func caseLongCliqued(indexPath:IndexPath) {
        
        switch gameStatu {
        case .off:
            gameStatu = .on
            startGame()
            flagCase(indexPath: indexPath)
        case .on:
            flagCase(indexPath: indexPath)
        case .ended:
            return
        }
    }
    private func flagCase(indexPath:IndexPath) {
        
        // On traite le cas ou la case porte un flag
        if gameDistribution[indexPath.section][indexPath.row].flag != .none {
            gameDistribution[indexPath.section][indexPath.row].resetFlag()
        } else {
            gameDistribution[indexPath.section][indexPath.row].putFlag()
        }
        self.delegate?.flagMine(nMine: gameLevel.nBombe() - gameDistribution.flatMap{$0}.filter{$0.flag == .mine}.count)
        self.delegate?.returnCase(indexPaths: [indexPath])
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


