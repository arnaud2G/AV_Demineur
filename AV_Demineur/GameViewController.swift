//
//  ViewController.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 21/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // Taille fixe car
    let size:CGFloat = UIScreen.main.bounds.width/CGFloat(GameLevel.easy.nCase().0)
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var cvGame: UICollectionView!
    
    var gameManager:GameManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvGame.delegate = self
        cvGame.dataSource = self
        
        // On commence une nouvelle partie
        gameManager = GameManager(gameLevel: .easy)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Gestion de la collectionView
extension GameViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameManager.gameDistribution.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineCell", for: indexPath)
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.borderWidth = 1
        (cell.viewWithTag(1) as! UILabel).text = "\(gameManager.gameDistribution[indexPath.row].value)"
        if gameManager.gameDistribution[indexPath.row].statu == .mine {
            (cell.viewWithTag(1) as! UILabel).text = "X"
        }
        return cell
    }
}

