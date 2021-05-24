//
//  FoodAdderController.swift
//  PHYSID
//
//  Created by Apple on 30.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "FoodAdderCell"

protocol FoodAdderControllerDelegate: class {
    func controller(_ controller: FoodAdderController, wantsToCreate food: Food)
}

class FoodAdderController: UITableViewController {
    
    // MARK: - Properties
    
    private lazy var headerView = FoodAdderHeader()
    private let imagePicker = UIImagePickerController()
    
    var selectedImage: UIImage? {
        didSet { headerView.foodImage.image = selectedImage }
    }
    weak var delegate: FoodAdderControllerDelegate?
    
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
        configureNavigationBar(withTitle: "Add a new food!",titleView: nil, backgroundcolor: .clear, titleColor: .black, prefersLargeTitles: false)
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
        tableView.register(FoodAdderCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

// MARK: - UITableViewDataSource

extension FoodAdderController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FoodAdderCell
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FoodAdderController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

// MARK: - FoodAdderHeaderDelegate

extension FoodAdderController: FoodAdderHeaderDelegate {
    func saveFoodInfo(_ cell: FoodAdderHeader) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension FoodAdderController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}


