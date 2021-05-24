//
//  WorkoutContentController.swift
//  PHYSID
//
//  Created by Apple on 21.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation
import YoutubeDirectLinkExtractor

protocol WorkoutContentControllerDelegate: class {
    func reloadThroughRemoval(_ controller: WorkoutContentController)
}

private let reuseIdentifier = "WorkoutContentCell"
private let headerIdentifier = "WorkoutContentHeader"


class WorkoutContentController: UIViewController {
    
    // MARK: - Properties
    
    private var workoutContent: WorkoutContent!
    weak var delegate: WorkoutContentControllerDelegate?
    private lazy var headerView = WorkoutContentHeader()
    var collectionView: UICollectionView!
    var playerViewController = AVPlayerViewController()
    
    private lazy var editContentButton: UIButton = {
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
        button.addTarget(self, action: #selector(handleEditContent), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    init(workoutContent: WorkoutContent) {
        self.workoutContent = workoutContent
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
        let iv = UIImageView(image: #imageLiteral(resourceName: "navigationbarlogo"))
        iv.contentMode = .scaleAspectFit
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditContent() {
        
        let controller = WorkoutContentEditorController(workoutContent: workoutContent)
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
        collectionView.register(WorkoutContentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(WorkoutContentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            if user.isAdmin {
                self.view.addSubview(self.editContentButton)
                self.view.bringSubviewToFront(self.editContentButton)
                self.editContentButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingBottom: 30, paddingRight: 30, width: 52, height: 52)
                self.editContentButton.isEnabled = true
                self.editContentButton.isHidden = false
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension WorkoutContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WorkoutContentCell
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension WorkoutContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! WorkoutContentHeader
         header.delegate = self
         header.workoutContent = self.workoutContent
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WorkoutContentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 1000)
    }
}

// MARK: - WorkoutContentHeaderDelegate


extension WorkoutContentController: WorkoutContentHeaderDelegate {
    func dismissalThroughRemove(_ header: WorkoutContentHeader) {
        self.dismiss(animated: true) {
            self.delegate?.reloadThroughRemoval(self)
        }
    }
    
    func handlePlayVideo() {
        print("played")
    }
    
    
}

// MARK: - WorkoutContentEditorControllerDelegate


extension WorkoutContentController: WorkoutContentEditorControllerDelegate {
    func controller(_ controller: WorkoutContentEditorController, wantsToUpdate workoutContent: WorkoutContent) {
        Service.saveWorkoutContentData(workoutContent: workoutContent) { (err, ref) in
            print(workoutContent.title)
        }
    }
    
    func handleDismiss(_ controller: WorkoutContentEditorController) {
        controller.dismiss(animated: true) {
            Service.fetchWorkoutContent(contentId: self.workoutContent.contentId) { (workoutContent) in
                self.workoutContent = workoutContent
                self.collectionView.reloadData()
            }
        }
    }
    
    
}
