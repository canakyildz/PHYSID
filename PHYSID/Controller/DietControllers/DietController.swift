//
//  DietController.swift
//  PHYSID
//
//  Created by Apple on 15.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "DietCell"
private let secondIdentifier = "RecipesCell"
private let secondaryHeaderIdentifier = "RecipesHeader"

class DietController: UIViewController {
    
    // MARK: - Properties
    
    var foods = [Food]()
    var user: User?
    var breakfastFoods = [Food]()
    var lunchFoods = [Food]()
    var dinnerFoods = [Food]()
    private var filteredFoods = [Food]() {
        didSet { secondaryView.reloadData() }}
    
    var userDietType: String?
    
    private var inSearchMode: Bool {
        return !headerView.searchGuy.text!.isEmpty || headerView.didSelect == true}
    
    private let scrollView = UIScrollView()
    private let filterBar = DietFilterView()
    private let scheduleBar = ScheduleFilterView()
    private lazy var headerView = RecipesHeader()
    private let lackInfoController = LackInfoView()
    private lazy var breakfastView = BreakfastView()
    private lazy var lunchView = LunchView()
    private let controller = DietsController()
    private lazy var dinnerView = DinnerView()
    private lazy var userCardView: UserCard = {
        let uc = UserCard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapUserCard))
        uc.addGestureRecognizer(tap)
        uc.isUserInteractionEnabled = true
        return uc
    }()
    
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
    
    private lazy var addFoodButton: UIButton = {
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
        button.addTarget(self, action: #selector(handleAddFood), for: .touchUpInside)
        return button
    }()
    
    private let popularProsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Daily Must-intake \nCalories for You"
        label.alpha = 1
        return label
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDietFoods()
        fetchCurrentUser()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configureFilterBar()
        configureSecondayCollection()
        fetchFoods()
        
    }
    
    
    
    // MARK: - Selectors
    
    @objc func handleAddFood() {
        
        let controller = FoodAdderController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    
    // MARK: - API
    
    func fetchFoods() {
        Service.fetchFoods { (foods) in
            self.foods = foods
            self.secondaryView.reloadData()
        }
    }
    
    func fetchDietFoods() {
        Service.fetchFoods { (foods) in
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Service.fetchUser(withUid: uid) { (user) in
                
                
                self.user = user
                
                let dietType = user.dietType
                var sorterPattern: String = ""
                if dietType ==  "Standard" {
                    sorterPattern = "Standard"
                } else {
                    sorterPattern = dietType ?? "Standard"
                }
                
                let bodyGoal = user.bodyGoalType
                
                if bodyGoal == "Thinner look" {
                    if sorterPattern == "Standard" {
                        self.breakfastFoods = foods.filter({ $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats <= 10 && $0.proteins >= 10 && $0.calories < 350})
                        self.dinnerFoods = foods.filter({ $0.fats <= 10 && $0.proteins >= 10 && $0.calories < 200})
                        
                    } else {
                        self.breakfastFoods = foods.filter({ $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern) && $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats <= 10 && $0.proteins >= 10 && $0.calories < 350 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        self.dinnerFoods = foods.filter({ $0.fats <= 10 && $0.proteins >= 10 && $0.calories < 200 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        
                    }
                    
                } else if bodyGoal == "Gaining weight" {
                    
                    if sorterPattern == "Standard" {
                        
                        self.breakfastFoods = foods.filter({ $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats > 10 && $0.proteins > 0 && $0.calories < 350 })
                        self.dinnerFoods = foods.filter({ $0.fats > 10 && $0.proteins > 0 && $0.calories < 200})
                        
                    } else {
                        
                        self.breakfastFoods = foods.filter({ $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern) && $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats > 10 && $0.proteins > 0 && $0.calories < 350 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        self.dinnerFoods = foods.filter({ $0.fats > 10 && $0.proteins > 0 && $0.calories < 200 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        
                    }
                } else if bodyGoal == "Building muscle" {
                    
                    if sorterPattern == "Standard" {
                        
                        self.breakfastFoods = foods.filter({ $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats > 0 && $0.fats < 20 && $0.proteins >= 15 && $0.calories < 350 })
                        self.dinnerFoods = foods.filter({ $0.fats > 0 && $0.fats < 20 && $0.proteins >= 15  && $0.calories < 200 })
                        
                    } else {
                        
                        self.breakfastFoods = foods.filter({ $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern) && $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats > 0 && $0.fats < 20 && $0.proteins >= 15 && $0.calories < 350 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        self.dinnerFoods = foods.filter({ $0.fats > 0 && $0.fats < 20 && $0.proteins >= 15  && $0.calories < 200 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        
                    }
                } else if bodyGoal == "Lean bulking" {
                    
                    if sorterPattern == "Standard" {
                        
                        self.breakfastFoods = foods.filter({ $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats > 0 && $0.fats < 10 && $0.proteins > 0 && $0.calories < 350 })
                        self.dinnerFoods = foods.filter({ $0.fats > 0 && $0.fats < 10 && $0.proteins > 0   && $0.calories < 200 })
                        
                    } else {
                        
                        self.breakfastFoods = foods.filter({ $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern) && $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats > 0 && $0.fats < 10 && $0.proteins > 0 && $0.calories < 350 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        self.dinnerFoods = foods.filter({ $0.fats > 0 && $0.fats < 10 && $0.proteins > 0   && $0.calories < 200 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        
                    }
                    
                } else if bodyGoal == "Losing fat" {
                    
                    if sorterPattern == "Standard" {
                        
                        self.breakfastFoods = foods.filter({ $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats < 10 && $0.proteins > 0 && $0.calories < 350 })
                        self.dinnerFoods = foods.filter({ $0.fats < 10 && $0.proteins > 0   && $0.calories < 200 })
                        
                    } else {
                        
                        self.breakfastFoods = foods.filter({ $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern) && $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats < 10 && $0.proteins > 0 && $0.calories < 350 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        self.dinnerFoods = foods.filter({ $0.fats < 10 && $0.proteins > 0   && $0.calories < 200 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        
                    }
                    
                } else if bodyGoal == "No goals yet" {
                    
                    if sorterPattern == "Standard" {
                        
                        self.breakfastFoods = foods.filter({ $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats < 20 && $0.proteins > 0 && $0.calories < 350 })
                        self.dinnerFoods = foods.filter({ $0.fats < 20 && $0.proteins > 0  && $0.calories < 200 })
                        
                    } else {
                        
                        self.breakfastFoods = foods.filter({ $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern) && $0.calories < 200})
                        self.lunchFoods = foods.filter({ $0.fats < 20 && $0.proteins > 0 && $0.calories < 350 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        self.dinnerFoods = foods.filter({ $0.fats < 20 && $0.proteins > 0   && $0.calories < 200 && $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
                        
                    }
                }
                
                self.breakfastView.foods = self.breakfastFoods
                self.breakfastView.user = user
                self.lunchView.foods = self.lunchFoods
                self.lunchView.user = user
                self.dinnerView.foods = self.dinnerFoods
                self.dinnerView.user = user
                
                self.breakfastView.tableView.reloadData()
                self.lunchView.tableView.reloadData()
                self.dinnerView.tableView.reloadData()
                
                
            }
        }
        print("what")

    }
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            self.user = user
        }
        
    }
    
    // MARK: - Selectors
    
    @objc func handleTapUserCard() {
        let controller = LackInfoView()
        controller.isView = false
        controller.user = self.user
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            self.secondaryView.removeFromSuperview()
            self.firstView.removeFromSuperview()
            self.userCardView.removeFromSuperview()
            self.scrollView.removeFromSuperview()
            self.scrollView.contentSize = CGSize(width: 0, height: 0)
            self.breakfastView.removeFromSuperview()
            self.breakfastView.frame.size = CGSize(width: 0, height: 0)
            self.lunchView.removeFromSuperview()
            self.lunchView.frame.size = CGSize(width: 0, height: 0)
            self.dinnerView.removeFromSuperview()
            self.dinnerView.frame.size = CGSize(width: 0, height: 0)

        }
    }
    
    
    // MARK: - Helpers
    
    func configureFilterBar() {
        filterBar.delegate = self
        view.addSubview(filterBar)
        filterBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingLeft: 20,paddingRight: 20, height: 40)
        
    }
    
    func configureFirstCollection() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            self.user = user
            if user.bmr == 0.0 || user.bmr == nil || user.requiredCalories == 0.0 || user.requiredCalories == nil || user.height == nil || user.weight == nil || user.age == nil || user.gender == nil || user.dietType == nil || (user.bodyGoalType == nil || user.bodyGoalType == "-") ||  (user.activity == "-" || user.activity == nil) || ( user.gender == nil || user.gender == "-") || (user.dietType == "-" || user.dietType == nil) || user.bodyGoalType == "-" || user.bodyGoalType == nil {
                self.lackInfoController.isView = true
                guard let lackInfoVV = self.lackInfoController.view else { return }
                self.view.addSubview(lackInfoVV)
                self.lackInfoController.user = user
                self.lackInfoController.delegate = self
                lackInfoVV.setDimensions(height: self.view.frame.height - 150, width: self.view.frame.width - 50)
                lackInfoVV.anchor(top: self.filterBar.bottomAnchor, paddingTop: 20)
                lackInfoVV.centerX(inView: self.view)
                
            } else {
                
                self.popularProsLabel.text = "Detailed \nPersonal Information"
                self.dailyGivenDietLabel.text = "Personalized \nDaily Diet Schedule"
                
                self.breakfastView.delegate = self
                self.lunchView.delegate = self
                self.dinnerView.delegate = self
                self.userCardView.user = user
                
                let breakfastFoodCount = self.breakfastFoods.count
                let lunchFoodCount = self.lunchFoods.count
                let dinnerFoodCount = self.dinnerFoods.count
                print("food count 1 \(breakfastFoodCount)")

                let breakfastViewHeight = CGFloat(breakfastFoodCount * 80 + 120 + 60)
                let lunchgViewHeight = CGFloat(lunchFoodCount * 80 + 120 + 60)
                let dinnerViewHeight = CGFloat(dinnerFoodCount * 80 + 120 + 60)
                
                self.view.addSubview(self.scrollView)
                self.scrollView.showsVerticalScrollIndicator = false
                self.view.bringSubviewToFront(self.scrollView)
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: breakfastViewHeight + lunchgViewHeight + dinnerViewHeight + 150 + 130 + 65 + 65)
                self.scrollView.anchor(top: self.filterBar.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
                self.scrollView.addSubview(self.popularProsLabel)
                self.popularProsLabel.anchor(top: self.scrollView.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 30, paddingLeft: 11, paddingRight: 10, height: 65)
                
                
                let vv = UIView()
                vv.layer.shadowColor = UIColor.black.cgColor
                vv.layer.shadowOffset = CGSize(width: 0.1, height: 0.2)
                vv.layer.shadowRadius = 2.6
                vv.backgroundColor = .white
                vv.layer.shadowOpacity = 0
                self.scrollView.addSubview(vv)
                vv.addSubview(self.userCardView)
                vv.anchor(top: self.popularProsLabel.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 5, paddingLeft: 4,paddingRight: 10, height: 130)
                
                self.userCardView.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2)
                self.scrollView.addSubview(self.dailyGivenDietLabel)
                self.dailyGivenDietLabel.anchor(top: self.userCardView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 15, paddingLeft: 11, paddingRight: 10, height: 65)
                self.scrollView.addSubview(self.scheduleBar)
                self.scheduleBar.anchor(top: self.dailyGivenDietLabel.bottomAnchor, left: self.dailyGivenDietLabel.leftAnchor, right: self.view.rightAnchor,paddingLeft: 5,paddingRight: 15, height: 40)

                self.scrollView.addSubview(self.breakfastView)
                self.breakfastView.anchor(top: self.scheduleBar.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor,paddingTop: 5, height: breakfastViewHeight + 20)
                self.scrollView.addSubview(self.lunchView)
                self.lunchView.anchor(top: self.breakfastView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, height: lunchgViewHeight + 20)
                self.scrollView.addSubview(self.dinnerView)
                
                self.dinnerView.anchor(top: self.lunchView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, height: dinnerViewHeight)
                
                
            }
        }
    }
    
    func configureSecondayCollection() {
        secondaryView = UITableView()
        secondaryView.delegate = self
        secondaryView.dataSource = self
        secondaryView.translatesAutoresizingMaskIntoConstraints = false
        secondaryView.separatorStyle = .none
        secondaryView.backgroundColor = .white
        secondaryView.tableHeaderView = headerView
        headerView.delegate = self
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: ((view.frame.height / 2) - (view.frame.height / 23)) )
        
        secondaryView.register(RecipesCell.self, forCellReuseIdentifier: secondIdentifier)
        view.addSubview(secondaryView)
        secondaryView.anchor(top:filterBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        
        guard let user = user else { return }
        if user.isAdmin {
            self.view.addSubview(self.addFoodButton)
            self.view.bringSubviewToFront(self.addFoodButton)
            self.addFoodButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor, paddingBottom: 30, paddingRight: 30, width: 52, height: 52)
            self.addFoodButton.isEnabled = true
            self.addFoodButton.isHidden = false
        }
        
    }
    
    func configureNav() {
        
        navigationController?.isNavigationBarHidden = true
        configureNavigationBar(withTitle: "",titleView: nil, backgroundcolor: .clear, titleColor: nil, prefersLargeTitles: false)
    }
    
    func doSelectionThroughDrops(filter: DietFilterOptions) {
        switch filter {
        
        case .recipes:
            
            secondaryView.removeFromSuperview()
            firstView.removeFromSuperview()
            guard let thirdView = controller.view else { return }
            thirdView.removeFromSuperview()
            lackInfoController.view.removeFromSuperview()
            userCardView.removeFromSuperview()
            scrollView.removeFromSuperview()
            breakfastView.removeFromSuperview()
            lunchView.removeFromSuperview()
            dinnerView.removeFromSuperview()
            configureSecondayCollection()
            controller.view.removeFromSuperview()
            configureFilterBar()
            
            fetchFoods()
            fetchDietFoods()

            
        case .myDiet:
            firstView.removeFromSuperview()
            secondaryView.removeFromSuperview()
            guard let thirdView = controller.view else { return }
            thirdView.removeFromSuperview()
            lackInfoController.view.removeFromSuperview()
            userCardView.removeFromSuperview()
            scrollView.removeFromSuperview()
            breakfastView.removeFromSuperview()
            lunchView.removeFromSuperview()
            dinnerView.removeFromSuperview()
            
            fetchDietFoods()
            configureFirstCollection()
            configureFilterBar()
            
            
        case .diets:
            firstView.removeFromSuperview()
            secondaryView.removeFromSuperview()
            guard let thirdView = controller.view else { return }
            thirdView.removeFromSuperview()
            lackInfoController.view.removeFromSuperview()
            userCardView.removeFromSuperview()
            scrollView.removeFromSuperview()
            breakfastView.removeFromSuperview()
            lunchView.removeFromSuperview()
            dinnerView.removeFromSuperview()
            
            view.addSubview(thirdView)
            thirdView.anchor(top: filterBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

         

        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DietController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension DietController: DietFilterViewDelegate {
    func filterView(_ view: DietFilterView, didSelect index: Int) {
        guard let filter = DietFilterOptions(rawValue: index) else { return }
        doSelectionThroughDrops(filter: filter)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension DietController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension DietController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredFoods.count : foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: secondIdentifier, for: indexPath) as! RecipesCell
        let food = inSearchMode ? filteredFoods[indexPath.row] : foods[indexPath.row]
        cell.food = food
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = inSearchMode ? filteredFoods[indexPath.row] : foods[indexPath.row]
        let foodProfile = FoodProfileController(food: food)
        let nav = UINavigationController(rootViewController: foodProfile)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
        
    }
}

// MARK: - RecipesHeaderDelegate


extension DietController: RecipesHeaderDelegate {
    func headerSorting(sorterPattern: String) {
        filteredFoods = foods.filter({ $0.foodTypeViewModel.localizedCaseInsensitiveContains(sorterPattern)})
    }
    
    func updateSearchResults(searchContent: String) {
        
        filteredFoods = foods.filter({ $0.foodName.localizedCaseInsensitiveContains(searchContent) ||  $0.foodTypeViewModel.localizedCaseInsensitiveContains(searchContent) })
    }
}

// MARK: - FoodProfileControllerDelegate

extension DietController: FoodProfileControllerDelegate {
    func reloadThroughDismissal(_ controller: FoodProfileController) {
        secondaryView.reloadData()
    }
}

// MARK: - LackViewDelegate

extension DietController: lackDelegate {
    func dismissalFromController(_ controller: LackInfoView) {
        print("ah, bi dont start yah")
        guard let filter = DietFilterOptions(rawValue: 1) else { return }
        doSelectionThroughDrops(filter: filter)
        print("waah?, bi dont start yah")        
    }
    
    
    
    func dismissal(_ view: LackInfoView) {
        
        self.fetchDietFoods()

        
        view.view.removeFromSuperview()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            self.user = user
            if user.bmr == 0.0 || user.bmr == nil || user.requiredCalories == 0.0 || user.requiredCalories == nil || user.height == nil || user.weight == nil || user.age == nil || user.gender == nil || user.dietType == nil || (user.bodyGoalType == nil || user.bodyGoalType == "-") ||  (user.activity == "-" || user.activity == nil) || ( user.gender == nil || user.gender == "-") || (user.dietType == "-" || user.dietType == nil) || user.bodyGoalType == "-" || user.bodyGoalType == nil {
                self.lackInfoController.isView = true
                guard let lackInfoVV = self.lackInfoController.view else { return }
                self.view.addSubview(lackInfoVV)
                self.lackInfoController.user = user
                self.lackInfoController.delegate = self
                lackInfoVV.setDimensions(height: self.view.frame.height - 150, width: self.view.frame.width - 50)
                lackInfoVV.anchor(top: self.filterBar.bottomAnchor, paddingTop: 20)
                lackInfoVV.centerX(inView: self.view)
                
            } else {
                
                self.popularProsLabel.text = "Detailed \nPersonal Information"
                self.dailyGivenDietLabel.text = "Personalized \nDaily Diet Schedule"
                
                self.breakfastView.delegate = self
                self.lunchView.delegate = self
                self.dinnerView.delegate = self
                self.userCardView.user = user
                
                let breakfastFoodCount = self.breakfastFoods.count
                let lunchFoodCount = self.lunchFoods.count
                let dinnerFoodCount = self.dinnerFoods.count
                print("food count 1 \(breakfastFoodCount)")

                let breakfastViewHeight = CGFloat(breakfastFoodCount * 80 + 120)
                let lunchgViewHeight = CGFloat(lunchFoodCount * 80 + 120)
                let dinnerViewHeight = CGFloat(dinnerFoodCount * 80 + 120)
                
                self.view.addSubview(self.scrollView)
                self.scrollView.showsVerticalScrollIndicator = false
                self.view.bringSubviewToFront(self.scrollView)
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: breakfastViewHeight + lunchgViewHeight + dinnerViewHeight + 150 + 130 + 65 + 65)
                self.scrollView.anchor(top: self.filterBar.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
                self.scrollView.addSubview(self.popularProsLabel)
                self.popularProsLabel.anchor(top: self.scrollView.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 30, paddingLeft: 11, paddingRight: 10, height: 65)
                
                let vv = UIView()
                vv.layer.shadowColor = UIColor.black.cgColor
                vv.layer.shadowOffset = CGSize(width: 0.1, height: 0.2)
                vv.layer.shadowRadius = 2.6
                vv.backgroundColor = .white
                vv.layer.shadowOpacity = 0
                self.scrollView.addSubview(vv)
                vv.addSubview(self.userCardView)
                vv.anchor(top: self.popularProsLabel.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 5, paddingLeft: 4,paddingRight: 10, height: 130)
                
                self.userCardView.anchor(top: vv.topAnchor, left: vv.leftAnchor, bottom: vv.bottomAnchor, right: vv.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2)
                self.scrollView.addSubview(self.dailyGivenDietLabel)
                self.dailyGivenDietLabel.anchor(top: self.userCardView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 15, paddingLeft: 11, paddingRight: 10, height: 65)
                
                self.scrollView.addSubview(self.breakfastView)
                self.breakfastView.anchor(top: self.dailyGivenDietLabel.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor,paddingTop: 5, height: breakfastViewHeight + 20)
                self.scrollView.addSubview(self.lunchView)
                self.lunchView.anchor(top: self.breakfastView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, height: lunchgViewHeight + 20)
                self.scrollView.addSubview(self.dinnerView)
                
                self.dinnerView.anchor(top: self.lunchView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, height: dinnerViewHeight)
                
                
            }
        }
        configureFilterBar()
    }
    
}

// MARK: - FoodProfileControllerDelegate

extension DietController: BreakfastViewDelegate {
    func presentFoodThroughBreakfastView(_ nav: UINavigationController) {
        self.present(nav, animated: true, completion: nil)
    }
    
    
}

extension DietController: LunchViewDelegate {
    func presentFoodThroughLunchView(_ nav: UINavigationController) {
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
}

extension DietController: DinnerViewDelegate {
    func presentFoodThroughDinnerView(_ nav: UINavigationController) {
        self.present(nav, animated: true, completion: nil)
    }
    
    
}
