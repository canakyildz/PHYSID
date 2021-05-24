//
//  MessageController.swift
//  Tinder
//
//  Created by Apple on 10.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ConversationCell"

class MessageController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    private var users = [User]()
    private lazy var headerView = MessageHeader()
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationsDictioanry = [String: Conversation]()
    
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
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
            self.fetchConversations()
            self.fetchUsers()
        }
        
        
    }
    
    // MARK: - Selectors
    
    @objc func showMainUI() {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - API
    
    func fetchConversations() {
        
        self.conversations.removeAll()
        self.tableView.reloadData()
        
        Service.fetchConversations { (conversations) in
            conversations.forEach { (conversation) in
                let message = conversation.message
                guard let partnerId = message.chatPartnerId else { return }

                self.conversationsDictioanry[partnerId] = conversation
            }
            self.conversations = Array(self.conversationsDictioanry.values)
            self.tableView.reloadData()
        }
    }
    
    func fetchUsers() {
        Service.fetchUsers(completion: { (users) in
            self.headerView.users = users
        })
    }
    
    // MARK: - Helpers
    
    
    func configureUI() {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.setDimensions(height: 26, width: 26)
        button.addTarget(self, action: #selector(showMainUI), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        configureTableView()
        view.backgroundColor = .white
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 210)
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        headerView.delegate = self
    }
}

// MARK: - UITableViewDelegate

extension MessageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.text = "Messages"
        label.frame = CGRect(x: 8, y: 6, width: view.frame.width, height: 20)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: - UITableViewDataSource

extension MessageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = conversations[indexPath.row].user.uid
        Service.fetchUser(withUid: uid!) { (user) in
            let chat = ChatController(user: user)
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
}

// MARK: - MessageHeaderDelegate

extension MessageController: MessageHeaderDelegate {
    func controller(_ controller: MessageHeader, wantsToStartChatWith matchedUserUid: String) {
        Service.fetchUser(withUid: matchedUserUid) { (user) in
            let chat = ChatController(user: user)
            let nav = UINavigationController(rootViewController: chat)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func controller(_ controller: MessageHeader, wantsToStartChatWith user: User) {
        let chatController = ChatController(user: user)
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    
}
