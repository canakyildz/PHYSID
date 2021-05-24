//
//  WorkoutContentEditorController.swift
//  PHYSID
//
//  Created by Apple on 2.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "WorkoutContentEditorCell"

protocol WorkoutContentEditorControllerDelegate: class {
    func controller(_ controller: WorkoutContentEditorController, wantsToUpdate workoutContent: WorkoutContent)
    func handleDismiss(_ controller: WorkoutContentEditorController)
}

class WorkoutContentEditorController: UITableViewController {
    
    
    // MARK: - Properties
    
    var workoutContent: WorkoutContent!
    private lazy var headerView = WorkoutContentEditorHeaderView()
    private let imagePicker = UIImagePickerController()
    
    var selectedImage: UIImage? {
        didSet { headerView.contentImage.image = selectedImage }
    }
    weak var delegate: WorkoutContentEditorControllerDelegate?
    
    
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
        configureImagePicker()
        configureNavigationBar()
        configureTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    
    // MARK: - Helpers
    
    func configureNavigationBar() {
        configureNavigationBar(withTitle: "Edit the workout content!",titleView: nil, backgroundcolor: .clear, titleColor: .black, prefersLargeTitles: false)
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), for: .normal)
        leftButton.setDimensions(height: 30, width: 30)
        leftButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.workoutContent = workoutContent
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1000)
        headerView.delegate = self
        tableView.register(FoodAdderCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

// MARK: - UITableViewDataSource

extension WorkoutContentEditorController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WorkoutContentEditorCell
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WorkoutContentEditorController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

// MARK: - FoodAdderHeaderDelegate

extension WorkoutContentEditorController: WorkoutContentEditorHeaderViewDelegate {
    func updateContentInfo(_ header: WorkoutContentEditorHeaderView) {
        delegate?.handleDismiss(self)
    }
    
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension WorkoutContentEditorController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}


