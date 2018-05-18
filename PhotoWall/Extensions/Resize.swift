//
//  Resize.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 18/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//
// reference: https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift

import UIKit

extension UIImage {
    
    /// Resize an UIImage to the desired size
    ///
    /// - Parameter targetSize: the desired size to rescale
    /// - Returns: the same image, rescaled
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
