//
//  DietContentController.swift
//  PHYSID
//
//  Created by Apple on 10.10.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "DietCell"
private let secondIdentifier = "RecipesCell"
private let secondaryHeaderIdentifier = "RecipesHeader"

class DietContentController: UIViewController {
    
    // MARK: - Properties
    
    var breakfastFoods = [Food]()
    var lunchFoods = [Food]()
    var dinnerFoods = [Food]()
    private var filteredFoods = [Food]() {
        didSet { secondaryView.reloadData() }}
    var diet: Diet?
    var userDietType: String?
    
    private let scrollView = UIScrollView()
    
    private let scheduleBar = ScheduleFilterView()
    private lazy var breakfastView = BreakfastView()
    private lazy var lunchView = LunchView()
    private lazy var dinnerView = DinnerView()
    private lazy var headerView = DietContentHeaderView()
    
    private var secondaryView: UITableView!
    private lazy var firstView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.register(DietCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    
    private let dailyGivenDietLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Daily Must-intake \nCalories for You"
        label.alpha = 1
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configureFirstCollection()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.isNavigationBarHidden = false

        configureNavigationBar(withTitle: "",titleView: nil, backgroundcolor: .clear, titleColor: .white, prefersLargeTitles: false)
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "icons8-back-50").withRenderingMode(.alwaysOriginal), for: .normal)
        leftButton.setDimensions(height: 30, width: 30)
        leftButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
        
    }
    
    // MARK: - Selectors
    
    @objc func handleAddFood() {
        
        let controller = FoodAdderController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleDismissal() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - API

    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    
    func configureFirstCollection() {
        
        dailyGivenDietLabel.text = "\nDaily Diet Schedule"
        
        breakfastView.delegate = self
        lunchView.delegate = self
        dinnerView.delegate = self
        
        let breakfastFoodCount = breakfastFoods.count
        let lunchFoodCount = lunchFoods.count
        let dinnerFoodCount = dinnerFoods.count
        
        let breakfastViewHeight = CGFloat(breakfastFoodCount * 80 + 120)
        let lunchgViewHeight = CGFloat(lunchFoodCount * 80 + 120)
        let dinnerViewHeight = CGFloat(dinnerFoodCount * 80 + 120)
        
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        view.bringSubviewToFront(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height : 2000)
        // kanka buraya size fonksiyonunu ekle APIler gelince aynnnennn big drip
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -50)
    
        scrollView.addSubview(headerView)
        headerView.diet = diet
        headerView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(dailyGivenDietLabel)
        dailyGivenDietLabel.anchor(top: headerView.bottomAnchor, paddingTop: 15, height: 65)
        dailyGivenDietLabel.centerX(inView: headerView)
        scrollView.addSubview(scheduleBar)
        scheduleBar.anchor(top: dailyGivenDietLabel.bottomAnchor, left: headerView.leftAnchor, right: view.rightAnchor,paddingLeft: 15,paddingRight: 15, height: 40)
        
        scrollView.addSubview(breakfastView)
        breakfastView.anchor(top: scheduleBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 5, height: breakfastViewHeight + 80)
        scrollView.addSubview(lunchView)
        lunchView.anchor(top: breakfastView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: lunchgViewHeight + 80)
        scrollView.addSubview(dinnerView)
        
        dinnerView.anchor(top: lunchView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: dinnerViewHeight + 80)
        
        
    }
    
    func configureNav() {
        
        navigationController?.isNavigationBarHidden = true
        configureNavigationBar(withTitle: "",titleView: nil, backgroundcolor: .clear, titleColor: nil, prefersLargeTitles: false)
    }
    
    func doSelectionThroughDrops(filter: ScheduleFilterOptions) {
//        switch filter {
//
//        case .monday:
//
//        case .tuesday:
//
//        case .wednesday:
//
//        case .thursday:
//
//        case .friday:
//
//        case .saturday:
//
//        case .sunday:
//
//        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DietContentController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meals.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DietCell
        cell.buttonImage.image = Meals(rawValue: indexPath.row)?.mealImage
        cell.titleLabel.text = "  \(Meals(rawValue: indexPath.row)?.description.uppercased() ?? "")"
        return cell
    }
}

extension DietContentController: ScheduleFilterViewDelegate {
    func filterView(_ view: ScheduleFilterView, didSelect index: Int) {
        guard let filter = ScheduleFilterOptions(rawValue: index) else { return }
        doSelectionThroughDrops(filter: filter)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension DietContentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}



// MARK: - FoodProfileControllerDelegate

extension DietContentController: FoodProfileControllerDelegate {
    func reloadThroughDismissal(_ controller: FoodProfileController) {
        secondaryView.reloadData()
    }
}


// MARK: - FoodProfileControllerDelegate

extension DietContentController: BreakfastViewDelegate {
    func presentFoodThroughBreakfastView(_ nav: UINavigationController) {
        self.present(nav, animated: true, completion: nil)
    }
    
    
}

extension DietContentController: LunchViewDelegate {
    func presentFoodThroughLunchView(_ nav: UINavigationController) {
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
}

extension DietContentController: DinnerViewDelegate {
    func presentFoodThroughDinnerView(_ nav: UINavigationController) {
        self.present(nav, animated: true, completion: nil)
    }
    
    
}
