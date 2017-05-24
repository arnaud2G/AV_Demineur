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

class DemineurLayoutAttributes:UICollectionViewLayoutAttributes {
    
    // 1. Custom attribute
    var cellSize: CGSize = CGSize.zero
    
    // 2. Override copyWithZone to conform to NSCopying protocol
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! DemineurLayoutAttributes
        copy.cellSize = cellSize
        return copy
    }
    
    // 3. Override isEqual
    override func isEqual(_ object: Any?) -> Bool {
        if let attributtes = object as? DemineurLayoutAttributes {
            if( attributtes.cellSize == cellSize  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}


class DemineurLayout: UICollectionViewLayout {
    //1. Pinterest Layout Delegate
    weak var delegate:DemineurLayoutProtocol!
    
    //2. Configurable properties
    var cellPadding: CGFloat = 2.0
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [DemineurLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentHeight:CGFloat {
        return self.delegate.sizeOfCell().width*CGFloat(self.delegate.numberOfSections())
    }
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return self.delegate.sizeOfCell().width*CGFloat(self.delegate.numberOfItems()) - (insets.left + insets.right)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return DemineurLayoutAttributes.self
    }
    
    override func prepare() {
        
        let numberOfColumn = self.delegate.numberOfItems()
        
        // 1. Only calculate once
        if cache.isEmpty {
            
            // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
            let columnWidth = contentWidth / CGFloat(numberOfColumn)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumn {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            
            // 3. Iterates through the list of items in the first section
            var column = 0
            for section in 0..<collectionView!.numberOfSections {
                
                let yOffset = CGFloat(section)*columnWidth
                
                for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                    
                    let indexPath = IndexPath(item: item, section: section)
                    
                    let frame = CGRect(x: xOffset[column], y: yOffset, width: columnWidth, height: columnWidth)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                    let attributes = DemineurLayoutAttributes(forCellWith: indexPath)
                    attributes.size = self.delegate.sizeOfCell()
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
        
        // Loop through the cache and look for items in the rect
        for attributes  in cache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
