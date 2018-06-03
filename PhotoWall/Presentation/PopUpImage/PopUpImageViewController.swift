//
//  PopUpViewController.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKTVOSKit
import FBSDKShareKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var shareButtonGuideView: UIView!
    @IBOutlet weak var leadingCaptionLabel: NSLayoutConstraint!
    
    var image: UIImage?
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image
        if let photo = self.photo {
            let format = DateFormatter()
            format.dateFormat = "dd/MM/yyyy HH:mm"
            
            if let date = self.photo?.date {
                captionLabel.text = "\(photo.name ?? "") \(format.string(from: date))"
            } else {
                captionLabel.text = "\(photo.name ?? "")"
            }
        }
        addFacebookShareButton()
    }
    
    // Add Facebook button to screen
    func addFacebookShareButton() {
        let button = FBSDKDeviceShareButton(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        button.center = shareButtonGuideView.center
        
        // TODO: Make direct photo share, not linkable
        let content = FBSDKShareLinkContent()
        content.contentURL = self.photo?.source
        button.shareContent = content
        self.view.addSubview(button)
        
        // Set leading constraint to caption label
        self.leadingCaptionLabel.constant = button.frame.origin.x + button.frame.width + 100
        
        // If custom button
        //FBSDKShareAPI.share(with: content, delegate: self)
    }
}

extension PopUpViewController: FBSDKSharingDelegate {
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        print("Sharing Completed!")
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        let alert = UIAlertController(title: "Sharing Failed",
                                      message: "There ws a problem sharing your message, please, try again later",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("User Canceled Share")
    }
}
