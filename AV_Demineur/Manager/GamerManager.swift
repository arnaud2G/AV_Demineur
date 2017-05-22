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
    
    func nCase() -> (Int,Int) {
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
    
    var timer:Timer?
    var gameTime:Double = 0
    
    var nBombToDisamorce:Int!
    var bombLocation = [Int]()
    var gameDistribution = [Case]()
    
    // A l'initialisation de la partie, on calcul la position des bombes
    let gameLevel:GameLevel
    init(gameLevel:GameLevel) {
        self.gameLevel = gameLevel
        initGame()
    }
    private func initGame() {
        
        // On cherche les bombes
        var myRandomTable = [Int]()
        myRandomTable += 0..<(gameLevel.nCase().0*gameLevel.nCase().1)
        
        for _ in 0..<gameLevel.nBombe() {
            let newIndex = myRandomTable[Int.random(lower: 0, upper: myRandomTable.count-1)]
            bombLocation.append(newIndex)
            myRandomTable.remove(at: myRandomTable.index(of: newIndex)!)
        }
        
        initDistribution()
    }
    
    // On calcul les cases
    private func initDistribution() {
        
        // On créé le tableau de mine
        gameDistribution = (0..<(gameLevel.nCase().0*gameLevel.nCase().1))
            .map({_ in return Case()})
        
        // On ajoute les bombes
        _ = bombLocation.map({
            (i:Int) -> Void in
            gameDistribution[i].statu = .mine
        })
        
        // On incrémentes les cases autours des bombes
        _ = bombLocation.map({
            (i:Int) in
            arround(i: i).map{gameDistribution[$0].value += 1}
        })
    }
    
    // On lance le timer
    func startGame() {
            timer = Timer.init(timeInterval: 0.01, repeats: true, block: {_ in 
                self.gameTime += 0.01
            })
    }
    
    // On récupère les cases à observer autours
    private func arround(i:Int) -> [Int] {
        
        var ret = [Int]()
        
        // Mouai...
        if caseShouldBeTested(i: i - gameLevel.nCase().0 - 1) {ret.append(i - gameLevel.nCase().0 - 1)}
        if caseShouldBeTested(i: i - gameLevel.nCase().0) {ret.append(i - gameLevel.nCase().0)}
        if caseShouldBeTested(i: i - gameLevel.nCase().0 + 1) {ret.append(i - gameLevel.nCase().0 + 1)}
        if caseShouldBeTested(i: i-1) {ret.append(i-1)}
        if caseShouldBeTested(i: i+1) {ret.append(i+1)}
        if caseShouldBeTested(i: i + gameLevel.nCase().0 - 1) {ret.append(i + gameLevel.nCase().0 - 1)}
        if caseShouldBeTested(i: i + gameLevel.nCase().0) {ret.append(i + gameLevel.nCase().0)}
        if caseShouldBeTested(i: i + gameLevel.nCase().0 + 1) {ret.append(i + gameLevel.nCase().0 + 1)}
        
        return ret
    }
    private func caseShouldBeTested(i:Int) -> Bool {
        if i < 0 || i >= gameLevel.nCase().0*gameLevel.nCase().1 {return false}
        if gameDistribution[i].statu == .mine {return false}
        return true
    }
    
    // On actionne une case, le retour permet de savoir si l'utilisateur à perdu
    func caseCliqued(i:Int) -> Bool {
        return gameDistribution[i].testCase()
    }
}


