//
//  ViewController.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import UIKit

protocol GameControllerProtocol:class {
    func startNewGame(gameDistributionView:[[CaseView]])
    func looser()
    func winner()
    func returnCase(indexPaths:[IndexPath])
    func flagMine(nMine:Int)
    func upChrono(time:Double)
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var cvGame: UICollectionView!
    
    var gameLevel:GameLevel!
    var gameManager:GameManager!
    var gameDistributionView = [[CaseView]]()
    
    deinit {
        print("deinit GameViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvGame.delegate = self
        cvGame.dataSource = self
        
        if let layout = cvGame.collectionViewLayout as? DemineurLayout {
            layout.delegate = self
        }
        
        
        // Gestion du clique long pour la pose des mines
        let lpgr:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        cvGame.addGestureRecognizer(lpgr)
        
        // On commence une nouvelle partie
        gameManager = GameManager(gameLevel: gameLevel)
        gameManager.delegate = self
        gameManager.initGame()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnResetPressed(_ sender: Any) {
        btnReset.setImage(#imageLiteral(resourceName: "Happy"), for: .normal)
        gameManager.initGame()
    }
}

// MARK: - Gestion de la collectionView
extension GameViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameManager.gameLevel.nCase().nRow
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameManager.gameLevel.nCase().nCol
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellGame", for: indexPath) as! CellGame
        cell.setCase(myCase: gameDistributionView[indexPath.section][indexPath.row])
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

// MARK: - Gestion du custom auto layout
extension GameViewController:DemineurLayoutProtocol {
    func sizeOfCell() -> CGSize {
        return gameManager.gameLevel.sizeCase(inCollectionView: cvGame)
    }
    
    func numberOfItems() -> Int {
        return gameManager.gameLevel.nCase().nCol
    }
    
    func numberOfSections() -> Int{
        return gameManager.gameLevel.nCase().nRow
    }
}


// MARK: - Gestion des actions de l'utilisateur
extension GameViewController:GameControllerProtocol {
    func startNewGame(gameDistributionView:[[CaseView]]) {
        self.gameDistributionView = gameDistributionView
        cvGame.reloadData()
    }
    func looser() {
        btnReset.setImage(#imageLiteral(resourceName: "Sad"), for: .normal)
        let alert = UIAlertController(title: nil, message: "Looooosssseeerrrrr", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func winner() {
        btnReset.setImage(#imageLiteral(resourceName: "Cool"), for: .normal)
        let alert = UIAlertController(title: nil, message: "GG !", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func returnCase(indexPaths: [IndexPath]) {
        cvGame.reloadItems(at: indexPaths)
    }
    
    func flagMine(nMine: Int) {
        self.lblScore.text = "\(nMine)"
    }
    
    func upChrono(time: Double) {
        self.lblTimer.text = "\(time)"
    }
}

// MARK: - Cellule du jeux
class CellGame:UICollectionViewCell {
    
    @IBOutlet weak var lblValue: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    func setCase(myCase:CaseView) {
        lblValue.text = myCase.caseText()
        lblValue.textColor = myCase.textColor()
        lblValue.backgroundColor = myCase.caseColor()
    }
}


