//
//  MenuViewController.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 23/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    
    @IBAction func btnEasyPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ToTheGame", sender: GameLevel.easy)
    }
    
    
    @IBAction func btnMediumPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ToTheGame", sender: GameLevel.medium)
    }
    
    
    @IBAction func btnHardPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ToTheGame", sender: GameLevel.hard)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameLevel = sender as? GameLevel else {return}
        let dvc = segue.destination as! GameViewController
        dvc.gameLevel = gameLevel
    }
}
