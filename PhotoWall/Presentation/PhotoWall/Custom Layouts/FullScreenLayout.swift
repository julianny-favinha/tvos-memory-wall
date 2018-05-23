//
//  FullScreenLayout.swift
//  photo-wall
//
//  Created by Julianny Favinha on 5/23/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class FullScreenLayout: CustomLayout {
    fileprivate var numberOfLines: Int = 1
    fileprivate var cellPadding: CGFloat = 30
    
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    fileprivate var contentWidth: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // Check if collection view is loaded
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let lineHeight = contentHeight - 50
        let yOffset: CGFloat = 25
        var line = 0
        var xOffset: [CGFloat] = [0]
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let width = collectionView.frame.width - 200
            let frame = CGRect(x: xOffset[line], y: yOffset, width: width, height: lineHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[line] = xOffset[line] + collectionView.frame.width
            
            line = line < (numberOfLines - 1) ? (line + 1) : 0
        }
    }
}
