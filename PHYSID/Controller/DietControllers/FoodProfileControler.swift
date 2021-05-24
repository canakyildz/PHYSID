//
//  FoodProfileControler.swift
//  PHYSID
//
//  Created by Apple on 20.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import AVFoundation
import YoutubeDirectLinkExtractor

private let reuseIdentifier = "FoodProfileCell"
private let headerIdentifier = "FoodHeaderView"

protocol FoodProfileControllerDelegate: class {
    func reloadThroughDismissal(_ controller: FoodProfileController)
    
}

class FoodProfileController: UIViewController {
    
    // MARK: - Properties
    
    private var food: Food!
    private lazy var headerView = FoodHeaderView()
    weak var delegate: FoodProfileControllerDelegate?
    var collectionView: UICollectionView!
    var playerViewController = AVPlayerViewController()
    
    private lazy var editFoodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-edit-50"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 33, width: 33)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.isHidden = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleEditFood), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(food: Food) {
        self.food = food
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.isNavigationBarHidden = false

        configureNavigationBar(withTitle: "",titleView: nil, backgroundcolor: .clear, titleColor: .white, prefersLargeTitles: false)
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), for: .normal)
        leftButton.setDimensions(height: 30, width: 30)
        leftButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
        
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        self.dismiss(animated: true) {
            self.delegate?.reloadThroughDismissal(self)
        }
    }
    
    @objc func handleEditFood() {
        
        let controller = FoodEditorController(food: food)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureTableView() {
        
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FoodProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(FoodHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            if user.isAdmin {
                self.view.addSubview(self.editFoodButton)
                self.view.bringSubviewToFront(self.editFoodButton)
                self.editFoodButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingBottom: 30, paddingRight: 30, width: 52, height: 52)
                self.editFoodButton.isEnabled = true
                self.editFoodButton.isHidden = false
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FoodProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FoodProfileCell
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FoodProfileController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! FoodHeaderView
        header.delegate = self
        header.food = self.food
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FoodProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 1900)
    }
    
}

// MARK: - FoodHeaderViewDelegate

extension FoodProfileController: FoodHeaderViewDelegate {
    func handleRemovalOfFood() {
        Service.removeFood(food: self.food) { (err, ref) in
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    func handlePlayVideo(withUrl recipeVideoUrl: String) {
        print(recipeVideoUrl)
        let player = AVPlayer(url: URL(string: recipeVideoUrl)!)
        DispatchQueue.main.async {
            self.playerViewController.player = player
            self.present(self.playerViewController, animated: true) {
                self.playerViewController.player!.play()
            }
        }
    }
    
    //    func handlePlayVideo() {
    ////        let y = YoutubeDirectLinkExtractor()
    ////        y.extractInfo(for: .urlString("https://www.youtube.com/watch?v=wkwz24t1qQo"), success: { info in
    //
    ////        }) { error in
    ////            print(error)
    ////        }
    //    }
}

// MARK: - FoodEditorControllerDelegate

extension FoodProfileController: FoodEditorControllerDelegate {
    func controller(_ controller: FoodEditorController, wantsToUpdate food: Food) {
        Service.saveFoodData(food: food) { (err, ref) in
            print(food.foodName)
        }
    }
    
    func handleDismiss(_ controller: FoodEditorController) {
        controller.dismiss(animated: true) {
            Service.fetchFood(foodId: self.food.foodId) { (food) in
                self.food = food
                self.collectionView.reloadData()
            }
        }
    }
}
