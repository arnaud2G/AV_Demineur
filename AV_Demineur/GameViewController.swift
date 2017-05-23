//
//  ViewController.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import UIKit

protocol GameControllerProtocol {
    func looser()
    func winner()
    func returnCase(indexPaths:[IndexPath])
}

class GameViewController: UIViewController {
    
    // Taille fixe car
    let size:CGFloat = UIScreen.main.bounds.width/CGFloat(GameLevel.easy.nCase().0)
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var cvGame: UICollectionView!
    
    var gameManager:GameManager!
    var gameDistributionView:[[CaseView]]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvGame.delegate = self
        cvGame.dataSource = self
        
        // Gestion du clique long pour la pose des mines
        let lpgr:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        cvGame.addGestureRecognizer(lpgr)
        
        // On commence une nouvelle partie
        gameManager = GameManager(gameLevel: .easy)
        gameManager.delegate = self
        gameDistributionView = gameManager.gameDistribution.map({
            (cases:[Case]) -> [CaseView] in
            let casesView:[CaseView] = cases.map({
                (aCase:Case) -> CaseView in
                return CaseView(initCase: aCase)
            })
            return casesView
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Gestion de la collectionView
extension GameViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameManager.gameLevel.nCase().nCol
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameManager.gameLevel.nCase().nRow
        //return gameDistributionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineCell", for: indexPath)
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.borderWidth = 1
        (cell.viewWithTag(1) as! UILabel).text = gameDistributionView[indexPath.section][indexPath.row].caseText()
        (cell.viewWithTag(1) as! UILabel).backgroundColor = gameDistributionView[indexPath.section][indexPath.row].caseColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gameManager.caseCliqued(indexPath: indexPath)
    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .began {
            
            let touchPoint = longPressGestureRecognizer.location(in: cvGame)
            if let indexPath = cvGame.indexPathForItem(at: touchPoint) {
                gameManager.caseLongCliqued(indexPath: indexPath)
            }
        }
    }
}


// MARK: - Gestion des actions de l'utilisateur
extension GameViewController:GameControllerProtocol {
    func looser() {
        print("looser")
    }
    
    func winner() {
        print("winner")
    }
    
    func returnCase(indexPaths: [IndexPath]) {
        cvGame.reloadItems(at: indexPaths)
    }
}

