//
//  CustomLayout.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 19/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//
// Refence: https://www.raywenderlich.com/164608/uicollectionview-custom-layout-tutorial-pinterest-2

import UIKit

class LinedGridLayout: CustomLayout {
    
    fileprivate var numberOfLines = 2
    fileprivate var cellPadding: CGFloat = 20
    
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
    
    init(numberOfLines: Int) {
        super.init()
        self.numberOfLines = numberOfLines
    }
    
    // Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        
        // Check if collection view is loaded
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let lineHeight = contentHeight / CGFloat(numberOfLines)
        var yOffset: [CGFloat] = []
        for line in 0 ..< numberOfLines {
            yOffset.append(CGFloat(line) * lineHeight)
        }
        var line = 0
        var xOffset = [CGFloat](repeating: 0, count: numberOfLines)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            let photoWidth = delegate.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath)
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
    
}