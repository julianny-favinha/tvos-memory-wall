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
    fileprivate var cellPadding: CGFloat = 30
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    fileprivate var contentWidth: CGFloat = 0
    
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        
        // Check if collection view is loaded
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
            let photoWidth = max(collectionView.frame.size.width - 800,
                                 delegate.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath))
            let width = cellPadding * 2 + photoWidth
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
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.item >= cache.count {
            self.prepare()
        }
        return cache[indexPath.item]
    }
    
}
