////
////  FeedFilterView.swift
////  PHYSID
////
////  Created by Apple on 18.08.2020.
////  Copyright © 2020 PHYSID. All rights reserved.
////
//
//import UIKit
//
//protocol FeedFilterViewDelegate: class {
//    func showBlurView(_ view: FeedFilterView)
//}
//
//private let reuseIdentifier = "FeedFilterCell"
//
//class FeedFilterView: UIView {
//    
//    
//    // MARK: - Properties
//    
//    var user: User
//    private lazy var viewModel = FeedContentOptionsViewModel(user: user)
//    weak var delegate: FeedFilterViewDelegate?
//    var tableView: UITableView!
//    var showFilter = false
//    
//    
//    // MARK: - Lifecycle
//    
//    
//    init(user: User) {
//        self.user = user
//        super.init(frame: .zero)
//        configureTableView()
//        backgroundColor = .clear
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Selectors
//    
//    @objc func dropFilters() {
//        showFilter = !showFilter
//        var indexPaths = [IndexPath]()
//        FeedFilters.allCases.forEach { (filter) in
//            let indexPath = IndexPath(row: filter.rawValue, section: 0)
//            indexPaths.append(indexPath)
//        }
//        
//        if showFilter {
//            tableView.insertRows(at: indexPaths, with: .fade)
//            delegate?.showBlurView(self)
//            
//        } else {
//            tableView.deleteRows(at: indexPaths, with: .fade)
//        }
//    }
//    
//    @objc func handleDismissal() {
//        showFilter = true
//    }
//    
//    // MARK: - Helpers
//    
//    func configureTableView() {
//        tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.separatorStyle = .none
//        tableView.rowHeight = 80
//        tableView.isScrollEnabled = false
//        tableView.register(FeedFilterCell.self, forCellReuseIdentifier: reuseIdentifier)
//        
//        addSubview(tableView)
//        bringSubviewToFront(tableView)
//        tableView.backgroundColor = .clear
//        tableView.anchor(top: topAnchor,left: leftAnchor, bottom: bottomAnchor,right:rightAnchor)
//        tableView.layer.cornerRadius = 0
//        tableView.heightAnchor.constraint(equalToConstant: 320).isActive = true
//        tableView.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        
//        
//    }
//    
//    func doSelectionThroughDrops(buttonsSelection: FeedFilters) {
//        switch buttonsSelection {
//            
//        case .SecondButton:
//            print("button2")
//            
//        }
//    }
//    
//}
//
//
//// MARK: UITableViewDelegate, UITableViewDataSource
//
//extension FeedFilterView: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return showFilter ? FeedFilters.allCases.count : 0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        40
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedFilterCell
//        cell.buttonImage.image = FeedFilters(rawValue: indexPath.row)?.image.withTintColor(.white)
//        cell.label.text = viewModel.options[indexPath.row].description
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let button = UIButton(type: .system)
//        button.setTitle("o", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 20
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        button.addTarget(self, action: #selector(dropFilters), for: .touchUpInside)
//        button.backgroundColor = .black
//        return button
//        
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let filter = FeedFilters(rawValue: indexPath.row) else { return }
//        doSelectionThroughDrops(buttonsSelection: filter)
//        
//    }
//    
//}
