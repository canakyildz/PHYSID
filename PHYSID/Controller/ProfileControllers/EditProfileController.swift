//
//  EditProfileController.swift
//  PHYSID
//
//  Created by Apple on 25.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    private lazy var headerView = EditProfileHeader()
    private let imagePicker = UIImagePickerController()
    
    weak var delegate: EditProfileControllerDelegate?
    private var userInfoChanged = false
    private var isFromProfileImage: Bool = false
    private var imageChanged: Bool {
        return selectedImage != nil || selectedBackgroundImage != nil
    }
    
    private var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage }
    }
    
    private var selectedBackgroundImage: UIImage? {
        didSet { headerView.bigView.image = selectedBackgroundImage }
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
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
    
    @objc func handleDone() {
        view.endEditing(true)
        guard imageChanged || userInfoChanged else { return }
        
        updateUserData()
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            self.user = user
        }
    }
    
    func updateUserData() {
        if imageChanged && !userInfoChanged {
            print("DEBUG: Changed image and not data")
            if self.isFromProfileImage {
                self.updateProfileImage()
            } else {
                self.updateBackImage()
            }
            
            if self.isFromProfileImage || !self.isFromProfileImage {
                self.updateBackImage()
                self.updateProfileImage()
            }
        }
        
        if userInfoChanged && !imageChanged {
            print("DEBUG: Changed data and not image..")
            Service.saveUserData(user: user) { (err, ref) in
                self.delegate?.controller(self, wantsToUpdate: self.user)
                let cell = EditProfileCell()
                cell.delegate = self
                
            }
        }
        
        if userInfoChanged && imageChanged {
            print("DEBUG: Changed both..")
            
            Service.saveUserData(user: user) { (err, ref) in
                if self.isFromProfileImage {
                    self.updateProfileImage()
                } else {
                    self.updateBackImage()
                }
                
                if self.isFromProfileImage || !self.isFromProfileImage {
                    self.updateBackImage()
                    self.updateProfileImage()
                }
            }
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        Service.uploadImage(image: image) { (profileImageUrl) in
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    func updateBackImage() {
        guard let image = selectedBackgroundImage else { return }
        Service.uploadImage(image: image) { (backgroundImageUrl) in
            self.user.backgroundImageUrl = backgroundImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    // MARK: - Helpers
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        headerView.delegate = self
        headerView.user = self.user
        
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
}

// MARK: - UITableViewDataSource

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 250 : 48
    }
}

// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeBackPhoto() {
        isFromProfileImage = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didTapChangeProfilePhoto() {
        isFromProfileImage = true
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        if isFromProfileImage == true {
            self.selectedImage = image
            
        } else {
            self.selectedBackgroundImage = image
        }
        
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewModel.option {
            
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.name = fullname
        case .professionType:
            guard let profession = cell.infoTextField.text else { return }
            user.professionType = profession
        case .location:
            guard let location = cell.infoTextField.text else { return }
            user.location = location
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}
