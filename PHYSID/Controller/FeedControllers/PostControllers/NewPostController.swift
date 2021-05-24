//
//  NewPostController.swift
//  PHYSID
//
//  Created by Apple on 27.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol NewPostControllerDelegate: class {
    func reloadThroughDismissal()
}

class NewPostController: UIViewController {
    
    
    // MARK: - Properties
    
    private var inSayMode: Bool
    weak var delegate: NewPostControllerDelegate?
    private let imagePicker = UIImagePickerController()

    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChoosePicture))
        iv.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        iv.isHidden = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var addPictureLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a picture"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    

    lazy var captionTextField: InputTextView = {
        let tf = InputTextView()
        tf.placeholderLabel.text = "What's your caption?"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.textAlignment = .left
        tf.layer.cornerRadius = 5
        tf.textColor = .black
        return tf
    }()
    
    lazy var titleTextField: InputTextView = {
        let tf = InputTextView()
        tf.placeholderLabel.text = "Main title of the post"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.textAlignment = .left
        tf.layer.cornerRadius = 5
        tf.textColor = .black
        return tf
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = true
        button.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(inSayMode: Bool) {
        self.inSayMode = inSayMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImagePicker()
        configureViewComponents()
        view.backgroundColor = #colorLiteral(red: 0.9351998731, green: 0.9351998731, blue: 0.9351998731, alpha: 1)
        
    }
    
    
    // MARK: - Selectors
    
    
    @objc func handleChoosePicture() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func showMainUI() {
        self.dismiss(animated: true) {
            self.delegate?.reloadThroughDismissal()
        }
    }
    
    @objc func sharePost() {
        if self.inSayMode == false {
            guard let caption = captionTextField.text else { return }
            guard let image = photoImageView.image else { return }
            guard let title = titleTextField.text else { return }
            Service.uploadImage(image: image) { (url) in
                let credentials = PostCredentials.init(caption: caption, title: title, postImageUrl: url, isSay: false)
                Service.uploadPost(credentials: credentials) { (err, ref) in
                    self.dismiss(animated:  true) {
                        print("mmm")
                    }
                }
            }
        } else {
            guard let title = titleTextField.text else { return }
            guard let caption = captionTextField.text else { return }
            let credentials = PostCredentials.init(caption: caption, title: title, postImageUrl: "", isSay: true)
            Service.uploadPost(credentials: credentials) { (err, ref) in
                self.dismiss(animated: true) {
                    print("oke")
                }
            }
        }
        
    }
    
    
    // MARK: - Helpers
    
    func configureViewComponents() {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.setDimensions(height: 26, width: 26)
        button.addTarget(self, action: #selector(showMainUI), for: .touchUpInside)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        if self.inSayMode == false {
            photoImageView.isHidden = false
            view.addSubview(photoImageView)
            photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor,paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, height: view.frame.width - 100)
            photoImageView.layer.cornerRadius = 10
            
            photoImageView.addSubview(addPictureLabel)
            photoImageView.bringSubviewToFront(addPictureLabel)
            addPictureLabel.setDimensions(height: 50, width: 150)
            addPictureLabel.centerX(inView: photoImageView)
            addPictureLabel.centerY(inView: photoImageView)
            
            view.addSubview(titleTextField)
            titleTextField.anchor(top: photoImageView.bottomAnchor, left: photoImageView.leftAnchor, right: photoImageView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: photoImageView.frame.width, height: 60)
            
            
            view.addSubview(captionTextField)
            captionTextField.anchor(top: titleTextField.bottomAnchor, left: photoImageView.leftAnchor, right: photoImageView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: photoImageView.frame.width, height: 100)
            
            
            view.addSubview(shareButton)
            shareButton.anchor(top: captionTextField.bottomAnchor, left: captionTextField.leftAnchor, right: captionTextField.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 40)
            
        } else {
            photoImageView.isHidden = true
            view.addSubview(titleTextField)
            titleTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, height: 60)
            

            view.addSubview(captionTextField)
            captionTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, height: 300)
            
            
            view.addSubview(shareButton)
            shareButton.anchor(top: captionTextField.bottomAnchor, left: captionTextField.leftAnchor, right: captionTextField.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 40)
        }
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}


// MARK: - UIImagePickerControllerDelegate

extension NewPostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.photoImageView.image = image
        self.addPictureLabel.alpha = 0
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}
