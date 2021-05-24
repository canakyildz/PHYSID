//
//  NewPostTypingView.swift
//  PHYSID
//
//  Created by Apple on 12.09.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

protocol NewPostDefinitiveViewDelegate: class {
}

class NewPostDefinitiveView: UIViewController {
    
    // MARK: - Properties
    
    var inSayMode: Bool = false
    weak var delegate: NewPostControllerDelegate?
    
    private let shareTextry: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-paste-as-text-96").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShareTextry), for: .touchUpInside)
        return button
    }()
    
    private let textryExplanation: UILabel = {
        let label = UILabel()
        label.text = "Textry Content"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let shareImagery: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-photo-gallery-96-2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShareImagery), for: .touchUpInside)
        return button
    }()
    
    private let imageryExplanation: UILabel = {
        let label = UILabel()
        label.text = "Imagery Content"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let visualEffectView = UIView()

    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureBlurView()
              configureUI()
        
    }
        
    // MARK: - Selectors
    
    @objc func handleShareTextry() {
        self.inSayMode = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            let controller = NewPostController(inSayMode: self.inSayMode)
            controller.delegate = self.delegate
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)

        }
    }
    
    @objc func handleShareImagery() {
        inSayMode = false
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            let controller = NewPostController(inSayMode: self.inSayMode)
            controller.delegate = self.delegate
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)

        }
    }


    @objc func handleDismissal() {

        self.dismiss(animated: true) {
            
        }

    }
    
    // MARK: - Handlers
    
    func configureUI() {

        let backView = UIView()
        view.addSubview(backView)
        backView.setDimensions(height: self.view.frame.width - 60, width: 200 )
        backView.centerX(inView: view)
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 20
        backView.centerY(inView: view)
        backView.layer.shadowOffset = CGSize(width: 0.1, height: 1)
        backView.layer.shadowOpacity = 0.4
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.cornerRadius = 20
        backView.backgroundColor = .white
        
        
        let stack = UIStackView(arrangedSubviews: [shareTextry, shareImagery])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        backView.addSubview(stack)
        stack.anchor(top: backView.topAnchor, left: backView.leftAnchor,bottom: backView.bottomAnchor, right: backView.rightAnchor,paddingTop: -10, paddingLeft: 0,paddingBottom: 25, paddingRight: 0)
        
        
        backView.addSubview(textryExplanation)
        backView.bringSubviewToFront(textryExplanation)

        textryExplanation.anchor(top: shareTextry.bottomAnchor, paddingTop: -30)
        textryExplanation.centerX(inView: shareTextry)

        let line = UnderLineView()
        view.addSubview(line)
        view.bringSubviewToFront(line)
        line.anchor(top: textryExplanation.bottomAnchor ,left: backView.leftAnchor, right: backView.rightAnchor, paddingTop: 30, height: 0.5)

        
        backView.addSubview(imageryExplanation)
        backView.bringSubviewToFront(imageryExplanation)
        imageryExplanation.anchor(top: shareImagery.bottomAnchor, paddingTop: -30)
        imageryExplanation.centerX(inView: shareImagery)
        
    }

    
    func configureBlurView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(tap)
        visualEffectView.backgroundColor = #colorLiteral(red: 0.9668067893, green: 0.9668067893, blue: 0.9668067893, alpha: 1)
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }, completion: nil)
        
    }
}
