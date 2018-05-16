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
import SwiftyJSON

let infiniteSize: Int = 100000000
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
    var isUpdatingImages: Bool = false

    var popUpImage: UIImage?
    var selectedIndexPath: IndexPath?
    
    let publicProfileServices = PublicProfileServices()
    let photosServices = PhotosServices()
    
    var photos: [Photo] = []
    var theme: PhotoWallTheme = PhotoPinTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Layout
        loadTheme()
        
        // Prevent Screen Block
        UIApplication.shared.isIdleTimerDisabled = true
        runButton.delegate = self
        
        // Start fetching data
        reloadCollectionViewSource()
    }
    
    /// Change the images Source
    func reloadCollectionViewSource() {
        // Check for the Facebook connection
        if FBSDKAccessToken.current() != nil {
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
    
    /// Load the PhotoWallTheme
    func loadTheme() {
        self.theme = PhotoWallThemes.themeDict[UserDefaultsManager.getPreferredTheme()]!
        self.view.backgroundColor = theme.backgroundColor
    }
    
    /// Change the photoWallTheme
    /// Update all displaying cells
    func restartTheme() {
        self.view.backgroundColor = theme.backgroundColor
        for cell in collectionView.visibleCells {
            if let cell = cell as? ImageCollectionViewCell {
                cell.theme = self.theme
            }
        }
        self.collectionView.reloadData()
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
            
            if FBSDKAccessToken.current() != nil {
                popUp.photo = photos[(selectedIndexPath?.row)!]
            } else {
                ODRManager.shared.requestPhotosWith(tag: CategoryPhotos.abstract.rawValue, onSuccess: {
                    // download abstract photos
                    let json = self.loadJsonFromLocalFile(filename: "Photos")
                    let imageModel = ImageModel.init(json: json, category: CategoryPhotos.abstract)
                    popUp.photo = imageModel.photos[(self.selectedIndexPath?.row)! % imageModel.photos.count]
                }, onFailure: { (error) in
                    print(error)
                })
            }
        }
    }

    /// Load json from a local file
    ///
    /// - Parameter filename: the name of the file to be loaded
    /// - Returns: return an JSON with the json loaded
    private func loadJsonFromLocalFile(filename: String) -> JSON {
        var data: String!
        
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                data = try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                print(error)
            }
        } else {
            print("ERROR: Word file not found: \(filename)")
        }
    
        return JSON(data)
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
        // Get cell of the current theme
        let cell = theme.createCell(for: indexPath, from: collectionView)
        cell.theme = self.theme
        
        if FBSDKAccessToken.current() != nil {
            //let urlObject = URL(string: self.photos[indexPath.row].source)
            // TODO: implementar uma fila did end display, cancelar operacao
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: self.photos[indexPath.row].source, placeholder: theme.placeholder)
        } else {
            // get image from ODRManager
//            cell.imageView.kf.setImage(with: ImageModel.getNextPhotoURL(), placeholder: theme.placeholder)

            ODRManager.shared.requestPhotosWith(tag: "defaultPhotos", onSuccess: {
                // TODO: code here!
            }, onFailure: { (error) in
                print(error)
            })
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
            self.selectedIndexPath = indexPath
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
                theme.transitionToSelectedState(cell: cell)
            }
        }
        // Unselected cell
        if let indexPath = context.previouslyFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                theme.transitionToUnselectedState(cell: cell)
            }
        }
    }
    
    /// Restart animation
    /// If the collection view scrolled *automatically* to the last image
    ///
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
        if indexPath.row > collectionView.numberOfItems(inSection: 0) - imageTreshold &&
            !isUpdatingImages {
            isUpdatingImages = true
            // Here, it should get more photos, not the initial ones
            print("Get more photos")
            photosServices.getPhotos { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.isUpdatingImages = false
                    }
                }
            }
        }
    }
}
