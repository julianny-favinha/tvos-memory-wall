//
//  ImagesViewController.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit

let infiniteSize: Int = 10000000

class PhotoWallViewController: UIViewController, MovementButtonDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var runButton: MovementButton!
    @IBOutlet weak var auxiliarview: UIView!
    @IBOutlet var hubButtons: [MovementButton]!

    var scrollAmount: Double = 0
    var timer: Timer = Timer()
    var scrollUpdateTime: Double = 0.01
    var scrollSpeed: Double = 1
    var isRunning: Bool = false

    var popUpImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Prevent Screen Block
        UIApplication.shared.isIdleTimerDisabled = true
        runButton.delegate = self

        if FBSDKAccessToken.current() != nil {
            // TODO: get photos from user
        } else {
            // standard photos
        }
    }

    @IBAction func runButtonPressed(_ sender: Any) {
        if isRunning {
            stopMoving()
            showInHub()
        } else {
            startMoving()
            fadeOutHub()
        }
    }

    /// Start the Collection View Scroll
    /// and hide the UI
    func startMoving() {
        print("Start Moving")
        fadeOutHub()
        isRunning = true
        scrollAmount = Double(collectionView.contentOffset.x)
        timer = Timer.scheduledTimer(timeInterval: scrollUpdateTime,
                                     target: self, selector: #selector(scrollCollectionView),
                                     userInfo: nil, repeats: true)
    }

    /// Stop Collection View Scroll
    /// and unhide the runButton
    func stopMoving() {
        print("Stop Moving")
        showInHub()
        isRunning = false
        timer.invalidate()
    }

    /// Fade out Hub
    func fadeOutHub() {
        for button in hubButtons {
            button.fadeOut()
        }
        UIView.animate(withDuration: 3) {
            self.auxiliarview.alpha = 0.0
        }
    }

    /// Show Hub
    func showInHub() {
        auxiliarview.layer.removeAllAnimations()
        auxiliarview.alpha = 1
        for button in hubButtons {
            button.showIn()
        }
    }

    /// Show a PopUpView according to the selected Image
    ///
    /// - Parameter image: UIImage
    func popUpImage(image: UIImage) {
        popUpImage = image
        self.performSegue(withIdentifier: "PopUpImageSegue", sender: self)
    }

    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUpImageSegue" {
            guard let popUp = segue.destination as? PopUpViewController else {
                return
            }
            popUp.image = popUpImage
        }
    }
}

extension PhotoWallViewController: UICollectionViewDataSource {
    @objc func scrollCollectionView() {
        scrollAmount += scrollSpeed
        self.collectionView?.contentOffset = CGPoint(x: scrollAmount, y: 0.0)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return infiniteSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as?
            ImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.imageView.image = ImageModel.getNextImage()
        return cell
    }
}

extension PhotoWallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath)")
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            self.popUpImage(image: cell.imageView.image!)
        }
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        print("Updated Focus")
        if let indexPath = context.nextFocusedIndexPath {
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
}
