//
//  WorkoutController.swift
//  PHYSID
//
//  Created by Apple on 15.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "WorkoutCell"

class WorkoutController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    private var sorterPattern: String?
    private var exceptionalFilteredContents = [WorkoutContent]()
    private var workoutContents = [WorkoutContent]()
    private var inExceptionalMode: Bool {
         headerView.didSelectFilter == true || !headerView.searchGuy.text!.isEmpty
    }
    private var conditionBasedHeaderView = WorkoutConditionBasedHeader()
    private var crossfitBasedHeaderView = WorkoutCrossFitBasedHeader()
    private lazy var headerView = WorkoutHeader()
    private var filteredContents = [WorkoutContent]()
    private var headerSorterPattern: String?
    
    private lazy var addContentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post-something"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 33, width: 33)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.isHidden = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleAddContent), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftBarButton: UIButton = {
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = .black
        leftButton.setDimensions(height: 30, width: 30)
        leftButton.addTarget(self, action: #selector(handleDis), for: .touchUpInside)
        return leftButton
    }()
    
    
    // MARK: - Lifecycle
    
    init(sorterPattern: String?) {
        self.sorterPattern = sorterPattern
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configureTableView()
        fetchContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContents()

    }
    
    // MARK: - Selectors
    
    @objc func handleAddContent() {
        
        let controller = WorkoutContentAdderController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleDis() {
        dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - API
    
    func fetchContents() {
        Service.fetchWorkoutContents { (workoutContents) in
            self.workoutContents = workoutContents
            guard let sorterPattern = self.sorterPattern else { return }
            self.filteredContents = workoutContents.filter({ $0.assignedPurposalType.contains(sorterPattern) })
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers

    
    func configureNav() {
        
        let iv = UIImageView(image: #imageLiteral(resourceName: "navigationbarlogo"))
        iv.contentMode = .scaleAspectFit
        navigationController?.isNavigationBarHidden = false
        configureNavigationBar(withTitle: sorterPattern,titleView: nil, backgroundcolor: .white, titleColor: .black, prefersLargeTitles: false)
        navigationController?.navigationBar.tintColor = .black
       
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
    }
    
    func configureTableView() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            if user.isAdmin {
                self.view.addSubview(self.addContentButton)
                self.view.bringSubviewToFront(self.addContentButton)
                self.addContentButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingBottom: 30, paddingRight: 30, width: 52, height: 52)
                self.addContentButton.isEnabled = true
                self.addContentButton.isHidden = false
            }
        }
        
        tableView = UITableView()
        tableView.delegate = self
        
        if sorterPattern == "Whole Workouts" || sorterPattern == "One Move" {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        headerView.delegate = self
        } else {
            
        }
        
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(tableView)
        
        
        if sorterPattern == "Condition Based" {
            tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -95 )
            tableView.tableHeaderView = conditionBasedHeaderView
            conditionBasedHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 320)
            leftBarButton.tintColor = .white
            configureNavigationBar(withTitle: sorterPattern,titleView: nil, backgroundcolor: .clear, titleColor: .white, prefersLargeTitles: false)

        }
        
        if sorterPattern == "CrossFit" {
            tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -95 )
            tableView.tableHeaderView = crossfitBasedHeaderView
            crossfitBasedHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 320)
            leftBarButton.tintColor = .white
            configureNavigationBar(withTitle: sorterPattern,titleView: nil, backgroundcolor: .clear, titleColor: .white, prefersLargeTitles: false)
        }
        
        

        
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension WorkoutController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("current filtering pattern is \(sorterPattern ?? "")")
        print("filtered Contents' count is  \(filteredContents.count)")
        return inExceptionalMode ? exceptionalFilteredContents.count : filteredContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WorkoutCell
        let workoutContent = inExceptionalMode ? exceptionalFilteredContents[indexPath.row] : filteredContents[indexPath.row]
        cell.workoutContent = workoutContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workoutContent = inExceptionalMode ? exceptionalFilteredContents[indexPath.row] : filteredContents[indexPath.row]
        let controller = WorkoutContentController(workoutContent: workoutContent)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
}

// MARK: - WorkoutHeaderDelegate

extension WorkoutController: WorkoutHeaderDelegate {
    func updateSearchResults(searchContent: String) {
        guard let sorterPattern = self.sorterPattern else { return }
        exceptionalFilteredContents = filteredContents.filter({ $0.assignedPurposalType.contains(sorterPattern) })
        exceptionalFilteredContents = filteredContents.filter({ $0.title.localizedCaseInsensitiveContains(searchContent) ||  $0.workoutContenttype.localizedCaseInsensitiveContains(searchContent) })
        tableView.reloadData()
        

    }

    func headerSorting(sorterPattern: String) {
        guard let sorterPatternOfOwn = self.sorterPattern else { return }
        self.headerSorterPattern = sorterPattern
        exceptionalFilteredContents = filteredContents.filter({ $0.assignedPurposalType.contains(sorterPatternOfOwn) })
        exceptionalFilteredContents = filteredContents.filter({ $0.workoutContenttype.localizedCaseInsensitiveContains(sorterPattern)})
        tableView.reloadData()
    }
}

// MARK: - WorkoutContentControllerDelegate


extension WorkoutController: WorkoutContentControllerDelegate {
    func reloadThroughRemoval(_ controller: WorkoutContentController) {
        self.tableView.reloadData()
        self.fetchContents()
    }
    
    
}
