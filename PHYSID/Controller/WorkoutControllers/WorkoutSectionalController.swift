//
//  WorkoutSectionalController.swift
//  PHYSID
//
//  Created by Apple on 3.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "WorkoutSectionalCell"
private let headerIdentifier = "UserCard"

class WorkoutSectionalController: UIViewController {
    
    // MARK: - Properties
    
    var sorterPattern: String?
    var user: User?
    
    private let lackInfoController = LackInfoView()
    lazy var firstView: UICollectionView = {
        let height = 0
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = false
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.register(WorkoutSectionalCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
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
    
    private let scrollView = UIScrollView()
    
    private lazy var userCardView: UserCard = {
        let uc = UserCard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapUserCard))
        uc.addGestureRecognizer(tap)
        uc.isUserInteractionEnabled = true
        return uc
    }()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        DispatchQueue.main.async {
            
            self.configureUI()
            self.configureFirstCollection()
            
        }
        
    }
    
    // MARK: -
    
    @objc func handleTapUserCard() {
        let controller = LackInfoView()
        controller.isView = false
        controller.user = self.user
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            self.firstView.removeFromSuperview()
            self.userCardView.removeFromSuperview()            
        }
        
    }
    
    
    // MARK: - Helpers
    
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
                lackInfoVV.anchor(top: self.view.topAnchor, paddingTop: 20)
                lackInfoVV.centerX(inView: self.view)
                
            } else {
                
                
                self.popularProsLabel.text = "Detailed \nPersonal Information"
                self.dailyGivenDietLabel.text = "Workout Contents"
                
                self.userCardView.user = user
                
                let collectionViewHeight = (self.view.frame.height / 4.5) * 7
                
                self.view.addSubview(self.scrollView)
                self.scrollView.showsVerticalScrollIndicator = false
                self.view.bringSubviewToFront(self.scrollView)
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: collectionViewHeight + 130 + 65 + 65 + 100)
                self.scrollView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor,right: self.view.rightAnchor)
                self.scrollView.addSubview(self.popularProsLabel)
                self.popularProsLabel.anchor(top: self.scrollView.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingLeft: 11, paddingRight: 10, height: 65)
                
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
                
                self.scrollView.addSubview(self.firstView)
                
                self.firstView.anchor(top: self.dailyGivenDietLabel.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, height: collectionViewHeight + 100)
            }
            
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension WorkoutSectionalController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorkoutSectionalSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WorkoutSectionalCell
        cell.buttonImage.image = WorkoutSectionalSections(rawValue: indexPath.row)?.sectionImage
        let text = " \(WorkoutSectionalSections(rawValue: indexPath.row)?.description ?? "All Contents")"
        cell.titleLabel.text = text.uppercased()
        cell.informativeLabel.text = WorkoutSectionalSections(rawValue: indexPath.row)?.information
        sorterPattern = text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: view.frame.height / 4.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let workoutSections = WorkoutSectionalSections(rawValue: indexPath.row)
        let text = workoutSections?.description
        
        switch workoutSections {
        
        case .MyProgram:
            let controller = WorkoutController(sorterPattern: text)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true) {
            }
        case .WholeWorkoutContents:
            let controller = WorkoutController(sorterPattern: text)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true) {
            }
        case .SpecificBodyParts:
            let controller = WorkoutController(sorterPattern: text)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true) {
            }
        case .CrossFitContents:
            let controller = WorkoutController(sorterPattern: text)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true) {
            }
        case .ConditionalWorkouts:
            let controller = WorkoutController(sorterPattern: text)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true) {
            }
        case .MyFavorites:
            let controller = WorkoutController(sorterPattern: text)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true) {
            }
            
        case .AllContents:
            let controller = WorkoutAllContentsController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true) {
                
            }
            
        case .none:
            let controller = WorkoutController(sorterPattern: text)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            
        }
    }
    
}

extension WorkoutSectionalController: lackDelegate {
    func dismissal(_ view: LackInfoView) {
        scrollView.removeFromSuperview()
        userCardView.removeFromSuperview()
        firstView.removeFromSuperview()
        dailyGivenDietLabel.removeFromSuperview()
        popularProsLabel.removeFromSuperview()
        
        configureFirstCollection()
        
    }
    
    func dismissalFromController(_ controller: LackInfoView) {
        scrollView.removeFromSuperview()
        userCardView.removeFromSuperview()
        firstView.removeFromSuperview()
        dailyGivenDietLabel.removeFromSuperview()
        popularProsLabel.removeFromSuperview()
        
        configureFirstCollection()
        
    }
    
    
}
