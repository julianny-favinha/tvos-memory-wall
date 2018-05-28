//
//  DefaultCollectionViewLayout.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 20/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class DefaultLayout: CustomLayout {
    fileprivate var numberOfLines = 1
    fileprivate var cellPadding: CGFloat = 60
    
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
        cache.removeAll()
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let lineHeight = contentHeight - 300
        var yOffset: [CGFloat] = []
        for line in 0 ..< numberOfLines {
            yOffset.append(CGFloat(line) * lineHeight + 150)
        }
        var line = 0
        var xOffset: [CGFloat] = [0]
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let maxWidth = collectionView.frame.size.width - 800
            let photoWidth = delegate.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath)
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)

            let realWidth = min(maxWidth, photoWidth)
            let realHeight = photoHeight * (realWidth / photoWidth)
            
            let proportion = (lineHeight - 2 * cellPadding) / realHeight
            let width = (cellPadding * 2) + (realWidth * proportion)
            
            let frame = CGRect(x: xOffset[line], y: yOffset[line], width: width, height: lineHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[line] = xOffset[line] + width
            
            line = line < (numberOfLines - 1) ? (line + 1) : 0
        }
    }
}
