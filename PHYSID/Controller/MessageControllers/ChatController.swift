//
//  ConversationController.swift
//  Tinder
//
//  Created by Apple on 10.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase


private let reuseIdentifier = "MessageCell"

class ChatController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let user: User?
    private var messages = [Message]()
    
    private lazy var customInputView: customInputAccessoryView = {
        let iv = customInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        
        return iv
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.configureUI()

        }
        
        DispatchQueue.global().async {
            self.fetchMessages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showMV))
        guard let user = user else { return }
        configureNavigationBar(withTitle: user.name, titleView: nil, backgroundcolor: .white, titleColor: .black, prefersLargeTitles: false)
    }
    
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    // MARK: - Selectors
    
    @objc func showMV() {
        dismiss(animated: true) {
            print("donesir")
        }
    }
    
    // MARK: - API
    
    func fetchMessages() {
        guard let user = user else { return }
        Service.fetchMessages(forUser: user) { (messages) in
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }}
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }}

// MARK: - CollectionViewDelegate

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }}

// MARK: - UICollectionViewDelegateFlowLayout


extension ChatController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        return .init(width: view.frame.width, height: estimatedSize.height)
    }}

// MARK: - CustomInputAccessoryViewDelegate

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: customInputAccessoryView, wantsToSend message: String) {
        guard let user = user else { return }
        Service.uploadMessage(message, to: user) { (err, ref) in
            print("test")
        }
            inputView.clearMessageText()
    }}
