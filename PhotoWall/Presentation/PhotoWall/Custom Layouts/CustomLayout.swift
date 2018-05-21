//
//  CustomLayoutProtocol.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 20/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewLayout {
    weak var delegate: CustomLayoutDelegate!
    
    // Cache to store layout attributes
    var cache = [UICollectionViewLayoutAttributes]()
    
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
