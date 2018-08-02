//
//  ImagesViewController.swift
//  Mover
//
//  Created by Giovani Nascimento Pereira on 09/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import FBSDKCoreKit

let imageTreshold: Int = 20

class PhotoWallViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var assistantView: UIView!
    @IBOutlet weak var assistantLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var updateActivity: UIActivityIndicatorView!
    
    // MARK: - Properties
    var scrollAmount: Double = 0
    var timer: Timer = Timer()
    var scrollUpdateTime: Double = 0.005
    var scrollSpeed: Double = 0.5
    var isRunning: Bool = false
    var isUpdatingImages: Bool = false

    var popUpImage: UIImage?
    var selectedIndexPath: IndexPath?
    var shouldStopMoving: Bool = true
    
    let publicProfileServices = PublicProfileServices()
    let photosServices = PhotosServices()
    
    var photos: [Photo] = []
    var theme: PhotoWallTheme {
        return ThemeManager.shared.currentTheme
    }
    var themeBackgroundView: UIView?
    var imageModel: ImageModel?

    // MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configures the collection view
        configureCollectionView()
        
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
        if UserDefaultsManager.getNumberOfExecutions() == 1 {
            self.displayMessage("Welcome to PhotoWall! Press the Play/Pause Button to start animating your wall. \n" +
                "Go to \"Settings\" to log into your accounts or to \"Albums\" to change the displayed photos.")
        }
    }
        
    // MARK: - Functions

    /// Timer to display message
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
    
    /// The button play/pause on Siri Remote is used to start/stop the flow of photo wall
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
            // Unselect cell
            if let focusedCell = UIScreen.main.focusedView as? UICollectionViewCell {
                self.theme.transitionToUnselectedState(cell: focusedCell)
            }
        }
    }
    
    /// Configures the collection view
    func configureCollectionView() {
        for nib in Cells.all {
            load(nib: Cells.identifier[nib]!, in: self.collectionView)
        }
    }
    
    func load(nib nibName: String, in collectionView: UICollectionView) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: nibName)
    }

    /// Change the images Source
    func reloadCollectionViewSource(option: PhotoRequestOptions) {
        self.photos = []
        self.activity.startAnimating()
        self.updateActivity.isHidden = false

        self.collectionView?.contentOffset = CGPoint(x: 0.0, y: 0.0)
        self.view.isUserInteractionEnabled = false
        
        // Check for the Facebook connection
        if FBSDKAccessToken.current() != nil {
            // user photos (uploaded only)
            photosServices.getPhotosFromSelectedAlbuns(options: option) { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.photos = []
                    self.photos.append(contentsOf: result)
                    DispatchQueue.main.async {
                        self.addLocalImages()
                    }
                }
            }
        } else {
            addLocalImages()
        }
    }
    
    func addLocalImages() {
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
            self.photos.shuffle()
            self.activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        self.loadTheme()
        
        self.updateActivity.isHidden = true
    }
    
    /// Load the PhotoWallTheme
    func loadTheme() {
        self.theme.collectionViewLayout.reloadLayout()
        self.view.backgroundColor = self.theme.backgroundColor
        
        // Restart Collection View Layout
        self.collectionView.collectionViewLayout = self.theme.collectionViewLayout
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
        self.theme.collectionViewLayout.reloadLayout()
        let layout = theme.collectionViewLayout
        layout.delegate = self
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.collectionViewLayout = theme.collectionViewLayout
        
        // Change background view
        updateBackgroundView()
        
        // Reload visible cells
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
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
                                     target: self,
                                     selector: #selector(scrollCollectionView),
                                     userInfo: nil,
                                     repeats: true)
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
