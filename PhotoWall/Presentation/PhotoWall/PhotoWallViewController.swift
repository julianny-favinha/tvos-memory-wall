//
//  ImagesViewController.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Kingfisher

let infiniteSize: Int = 10000000
let imageTreshold: Int = 10

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
    let publicProfileServices = PublicProfileServices()
    let photosServices = PhotosServices()
    
    var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Prevent Screen Block
        UIApplication.shared.isIdleTimerDisabled = true
        runButton.delegate = self

        if FBSDKAccessToken.current() != nil {
            // public profile information
            publicProfileServices.getPublicProfile { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Final result")
                    print(result)
                }
            }
            
            // user photos (uploaded only)
            photosServices.getPhotos { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
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
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if FBSDKAccessToken.current() != nil {
            return self.photos.count
        } else {
            return infiniteSize
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as?
            ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = #imageLiteral(resourceName: "placeholder")

        if FBSDKAccessToken.current() != nil {
            //let urlObject = URL(string: self.photos[indexPath.row].source)
            // TODO: implementar uma fila did end display, cancelar operacao
            cell.imageView.kf.setImage(with: self.photos[indexPath.row].source)
        } else {
            cell.imageView.image = ImageModel.getNextImage()
        }
        
        return cell
    }
}

extension PhotoWallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// Allows every cell to be selectable
    /// if false: the cell cannot be clicked
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Allows every cell to be focusable
    /// if false: the current cell will be selected using the remote
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// Select a collectionView item
    /// using siri-remote click
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView
    ///   - indexPath: the selected indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected indexPath: \(indexPath)")
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            self.popUpImage(image: cell.imageView.image!)
        }
    }

    /// Coordinate the change of focus inside the collection view
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView
    ///   - context: the current focus context
    ///   - coordinator: the animation coordinator
    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        // Selected cell
        if let indexPath = context.nextFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                cell.transitionToSelectedState(cell: cell)
            }
        }
        // Unselected cell
        if let indexPath = context.previouslyFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                cell.transitionToUnselectedState(cell: cell)
            }
        }
    }
    
    /// If the collection view scrolled *automatically* to the last image
    /// - restart animation
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Last cell left the screen on automatic scroll mode
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 &&
            isRunning == true {
            UIView.animate(withDuration: 1) {
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
                self.scrollAmount = 0
            }
        }
        
        // Get More URLs
        if indexPath.row > collectionView.numberOfItems(inSection: 0) - imageTreshold {
            // TODO: Make the service get new photos
            // Here, it should get more photos, not the initial ones
            print("Get more photos")
            photosServices.getPhotos { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
