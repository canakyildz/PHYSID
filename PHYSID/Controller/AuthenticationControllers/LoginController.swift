//
//  LoginController.swift
//  Tinder
//
//  Created by Apple on 23.07.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol AuthenticationCompletionDelegate: class {
    func configureViewsEarly()
}

class LoginController: UIViewController {
    
    // MARK: Properties
    
    weak var delegate: AuthenticationCompletionDelegate?
    
    private var viewModel = LoginViewModel()
    
    let workoutView: UIView = {
        let vv = UIView()
        let iv = UIImageView(image: #imageLiteral(resourceName: "Yoga Clothes _ Cut out the distractions just train_ | lululemon"))
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        iv.addSubview(effect)
        effect.anchor(top: iv.topAnchor, left: iv.leftAnchor, bottom: iv.bottomAnchor, right: iv.rightAnchor, paddingRight: 45)
        UIView.animate(withDuration: 1.4, delay: 0, options: .curveEaseOut, animations: {
            effect.frame.origin.x = +400
        }) { (_) in }
        iv.contentMode = .scaleAspectFill
        vv.addSubview(iv)
        iv.fillSuperview()
        return vv
    }()
    private let backView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Dikdörtgen 2"))
        return iv
    }()
    
    private let loginToWinda: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "Log into \nyour account"
        label.alpha = 0
        return label
    }()
    
    private let authButton: AuthButton = {
        let button = AuthButton(title: "Log In", type: .system, color: .white, backGroundColor: .black)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let secondaryAuth: AuthButton = {
        let button = AuthButton(title: "Log in with Google", type: .system, color: .black, backGroundColor: .white)
        return button
    }()
    
    private let toRegistrationButton: goToButton = {
        let button = goToButton(title: "Don't have an account?", sTitle: "  Sign Up", type: .system)
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailTextField = CustomTextField(titleholder: "Email")
    
    private lazy var passwordTextField = CustomTextField(titleholder: "Password", isSecureField: true)
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
        
        
    }
    
    // MARK: Selector
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.dismiss(animated: true) {
                self.delegate?.configureViewsEarly()
            }
            
        }
    }
    
    @objc func handleShowRegistration() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.isUserInteractionEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.5061478019, green: 0.2849369943, blue: 0.2865973115, alpha: 1)
            authButton.setTitleColor(.white, for: .normal)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = .black
            authButton.setTitleColor(.white, for: .normal)
        }
    }
    
    
    // MARK: Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        
        view.addSubview(workoutView)
        workoutView.anchor(top: view.topAnchor, left: view.leftAnchor,bottom: view.bottomAnchor, right: view.rightAnchor)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton, secondaryAuth])
        stack.axis = .vertical
        stack.spacing = 26
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingTop: 130, paddingLeft: 32, paddingRight: 62)
        stack.centerY(inView: view)
        
        view.addSubview(loginToWinda)
        loginToWinda.anchor(left: view.leftAnchor, bottom: stack.topAnchor, paddingLeft: 37, paddingBottom: 70)
        UIView.animate(withDuration: 1.2) {
            self.loginToWinda.frame.origin.y = +100
            self.loginToWinda.alpha = 1
        }
        
        view.addSubview(toRegistrationButton)
        toRegistrationButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 62)
        
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
