//
//  WorkoutContentAdderController.swift
//  PHYSID
//
//  Created by Apple on 2.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//


import UIKit
import Firebase

private let reuseIdentifier = "WorkoutContentAdderCell"

protocol WorkoutContentAdderControllerDelegate: class {
    func controller(_ controller: WorkoutContentAdderController, wantsToCreate workoutContent: WorkoutContent)
}

class WorkoutContentAdderController: UITableViewController {
    
    // MARK: - Properties
    
    private lazy var headerView = WorkoutContentAdderHeader()
    private let imagePicker = UIImagePickerController()
    
    var selectedImage: UIImage? {
        didSet { headerView.workoutImage.image = selectedImage }
    }
    weak var delegate: WorkoutContentAdderControllerDelegate?
    
    // MARK: - Lifecycle
    
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
        configureNavigationBar(withTitle: "Add a new content!",titleView: nil, backgroundcolor: .clear, titleColor: .black, prefersLargeTitles: false)
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), for: .normal)
        leftButton.setDimensions(height: 30, width: 30)
        leftButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1000)
        headerView.delegate = self
        tableView.register(WorkoutContentAdderCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

// MARK: - UITableViewDataSource

extension WorkoutContentAdderController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WorkoutContentAdderCell
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WorkoutContentAdderController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

// MARK: - WorkoutContentAdderHeaderDelegate

extension WorkoutContentAdderController: WorkoutContentAdderHeaderDelegate {
    func saveWorkoutInfo(_ cell: WorkoutContentAdderHeader) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension WorkoutContentAdderController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}


