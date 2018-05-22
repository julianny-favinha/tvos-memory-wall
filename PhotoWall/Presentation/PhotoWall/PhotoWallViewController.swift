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

let imageTreshold: Int = 10

class PhotoWallViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var assistantView: UIView!
    @IBOutlet weak var assistantLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
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
    var themeBackgroundView: UIView?
    var imageModel: ImageModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Layout
        loadTheme()
        
        // Prevent Screen Block
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Add button gesture
        addPlayPauseRecognizer()
        
        // Start fetching data
        reloadCollectionViewSource(option: .fromBegining)
        
        // Hide AssistantView
        self.assistantView.alpha = 0
        
        // First time executing the app
        if UserDefaultsManager.getNumberOfExecutions() == 0 {
            self.displayMessage("Welcome to PhotoWall! Press the Play/Pause Button to start animating your wall. \n" +
                "Go to \"Settings\" to log into your accounts or to \"Albums\" to change the displayed photos.")
        }
    }
    
    var assistantTimer: Timer = Timer()
    func displayMessage(_ message: String) {
        assistantTimer = Timer.scheduledTimer(timeInterval: 15, target: self,
                                              selector: #selector(hideMessage), userInfo: nil, repeats: false)
        self.assistantLabel.text = message
        UIView.animate(withDuration: 0.5) {
            self.assistantView.alpha = 1
        }
    }
    
    @objc func hideMessage() {
        UIView.animate(withDuration: 0.5) {
            self.assistantView.alpha = 0
        }
    }
    
    func addPlayPauseRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func playPauseTapped() {
        if isRunning {
            stopMoving()
        } else {
            startMoving()
        }
    }
    
    /// Change the images Source
    func reloadCollectionViewSource(option: PhotoRequestOptions) {
        self.photos = []
        self.activity.startAnimating()
        
        // Check for the Facebook connection
        if FBSDKAccessToken.current() != nil {
            // user photos (uploaded only)
            photosServices.getPhotosFromSelectedAlbuns(options: option) { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
        } else {
            // Get User selected local images
            let dict = UserDefaultsManager.getLocalImagesDict()
            var categoryArray: [CategoryPhotos] = []
            for (category, state) in dict! where state == true {
                categoryArray.append(CategoryPhotos(rawValue: category.lowercased())!)
            }
            
            let json = LoadJson.shared.json!
            self.imageModel = ImageModel.init(json: json, categories: categoryArray)
            if let localPhotos = self.imageModel?.photos {
                self.photos.append(contentsOf: localPhotos)
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    /// Load the PhotoWallTheme
    func loadTheme() {
        self.theme = PhotoWallThemes.themeDict[UserDefaultsManager.getPreferredTheme()]!
        self.view.backgroundColor = theme.backgroundColor
        
        // Restart Collection View Layout
        self.collectionView.collectionViewLayout = theme.collectionViewLayout
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        // Change background View
        updateBackgroundView()

        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
    }
    
    /// Change the photoWallTheme
    /// Update all displaying cells
    func restartTheme() {
        self.view.backgroundColor = theme.backgroundColor
        
        // Reload Layout to the selected Theme
        let layout = theme.collectionViewLayout
        if let customLayout = layout as? CustomLayout {
            customLayout.delegate = self
        }
        self.collectionView.collectionViewLayout = layout
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout = theme.collectionViewLayout
        
        //Change background view
        updateBackgroundView()
        
        // Reload visible cells
        for cell in collectionView.visibleCells {
            if let cell = cell as? ImageCollectionViewCell {
                cell.theme = self.theme
            }
        }
        self.collectionView.reloadData()
    }
    
    func updateBackgroundView() {
        // Remove old View
        self.themeBackgroundView?.removeFromSuperview()
        
        // Add new view
        if let view = theme.backgroundView {
            view.frame = backgroundView.frame
            self.themeBackgroundView = view
            self.backgroundView.addSubview(themeBackgroundView!)
        }
    }

    /// Start the Collection View Scroll
    /// and hide the UI
    func startMoving() {
        isRunning = true
        scrollAmount = Double(collectionView.contentOffset.x)
        timer = Timer.scheduledTimer(timeInterval: scrollUpdateTime,
                                     target: self, selector: #selector(scrollCollectionView),
                                     userInfo: nil, repeats: true)
    }

    /// Stop Collection View Scroll
    /// and unhide the runButton
    func stopMoving() {
        isRunning = false
        timer.invalidate()
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
                popUp.photo = self.photos[(self.selectedIndexPath?.row)! % self.photos.count]
            }
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
            if photos.count == 0 {
                return 50
            }
            return photos.count
        }
    }
    
    private func definePlaceholder(width: Int, height: Int) -> UIImage {
        if height > width {
            return #imageLiteral(resourceName: "placeholder2")
        }
        
        return #imageLiteral(resourceName: "placeholder1")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get cell of the current theme
        var cell = ImageCollectionViewCell()
        
        if FBSDKAccessToken.current() != nil {
            // TODO: implementar uma fila did end display, cancelar operacao
            // change placeholder
            theme.placeholder = definePlaceholder(width: self.photos[indexPath.row].width,
                                                  height: self.photos[indexPath.row].height)
            
            // create cell
            cell = theme.createCell(for: indexPath, from:
                collectionView, with: self.photos[indexPath.row])
            
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(
                with: self.photos[indexPath.row].source,
                placeholder: theme.placeholder,
                options: [.processor(theme.processor)],
                progressBlock: nil, completionHandler: nil)
        } else {
            theme.placeholder = definePlaceholder(width: (imageModel?.photos[indexPath.row].width)!,
                                                  height: (imageModel?.photos[indexPath.row].height)!)
            
            // Create cell
            cell = theme.createCell(for: indexPath, from:
                collectionView, with: (imageModel?.photos[indexPath.row % (imageModel?.photos.count)!])!)
            
            // get image from localPhotos
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(
                with: imageModel?.getNextPhotoURL(for: indexPath),
                placeholder: theme.placeholder,
                options: [.processor(theme.processor)],
                progressBlock: nil, completionHandler: nil)
        }
        cell.theme = self.theme
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
        stopMoving()
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
            // Updating images
            photosServices.getPhotosFromSelectedAlbuns(options: .nextImages) { (result, error) in
                if error != nil {
                    print("Photo Wall View Controller")
                    print(error!.localizedDescription)
                } else {
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                self.isUpdatingImages = false
            }
        }
    }
}

extension PhotoWallViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(photos[indexPath.item].height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= photos.count {
            return 100
        }
        return CGFloat(photos[indexPath.item].width)
    }
}
