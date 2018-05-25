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
    
    private var theme: PhotoWallTheme {
        return ThemeManager.shared.currentTheme
    }
    fileprivate var cellPadding: (vertical: CGFloat, horizontal: CGFloat) {
        return Cells.padding[theme.cell]!
    }
    
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
    
    init(numberOfLines: Int) {
        super.init()
        self.numberOfLines = numberOfLines
    }
    
    // Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        // Check if collection view is loaded to avoid calculating more than once
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let lineHeight = contentHeight / CGFloat(numberOfLines)
        var yOffset: [CGFloat] = []
        for line in 0 ..< numberOfLines {
            yOffset.append(CGFloat(line) * lineHeight)
        }
        var line = 0
        var xOffset: [CGFloat] = [CGFloat](repeating: 0, count: numberOfLines)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let maxWidth = collectionView.frame.size.width - 800
            let photoWidth = delegate.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath)
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            
            let realWidth = min(maxWidth, photoWidth)
            let realHeight = photoHeight * (realWidth / photoWidth)
            
            let proportion = (lineHeight - 2 * cellPadding.vertical) / realHeight
            let width = (cellPadding.horizontal * 2) + (realWidth * proportion)
            
            let frame = CGRect(x: xOffset[line], y: yOffset[line], width: width, height: lineHeight)
            let insetFrame = frame.insetBy(dx: cellPadding.horizontal, dy: cellPadding.vertical)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[line] = xOffset[line] + width
            
            line = line < (numberOfLines - 1) ? (line + 1) : 0
        }
    }
    
}
