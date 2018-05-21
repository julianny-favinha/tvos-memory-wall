//
//  SettingsPrivacyPolicyViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 15/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

class SettingsPrivacyPolicyViewController: UIViewController {

    weak var photoWallViewController: PhotoWallViewController?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.isUserInteractionEnabled = true
        self.textView.isSelectable = true
        self.textView.isScrollEnabled = true
        self.textView.showsVerticalScrollIndicator = true
        self.textView.bounces = true
        self.textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouchType.indirect.rawValue)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
