//
//  DemineurCustomLayout.swift
//  AV_Demineur
//
//  Created by 2Gather Arnaud Verrier on 24/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

protocol DemineurLayoutProtocol:class {
    func sizeOfCell() -> CGSize
    func numberOfSections() -> Int
    func numberOfItems() -> Int
}

class DemineurLayout: UICollectionViewLayout {
    
    weak var delegate:DemineurLayoutProtocol!
    
    
    var cellPadding: CGFloat = 2.0
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    // Taille de la collection view
    fileprivate var contentHeight:CGFloat {
        return self.delegate.sizeOfCell().width*CGFloat(self.delegate.numberOfSections())
    }
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return self.delegate.sizeOfCell().width*CGFloat(self.delegate.numberOfItems()) - (insets.left + insets.right)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return UICollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        
        // Le cache permet de ne pas tout recalculer si reload
        if cache.isEmpty {
            
            // On calcul les offsets
            let numberOfColumn = self.delegate.numberOfItems()
            let columnWidth = contentWidth / CGFloat(numberOfColumn)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumn {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            // On créé les attributs (particulièrement la frame) pour toutes les cellules
            var column = 0
            for section in 0..<collectionView!.numberOfSections {
                
                let yOffset = CGFloat(section)*columnWidth
                
                for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                    
                    let indexPath = IndexPath(item: item, section: section)
                    
                    let frame = CGRect(x: xOffset[column], y: yOffset, width: columnWidth, height: columnWidth)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    
                    column += 1
                }
                column = 0
            }
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in cache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
