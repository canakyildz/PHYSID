
//
//  RegisterController.swift
//  Tinder
//
//  Created by Apple on 23.07.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel = RegistrationViewModel()
    
    weak var delegate: AuthenticationCompletionDelegate?
    
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.text = "PHYSID"
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    lazy var firstView: UIView = {
        let vv = UIView()
        let iv = UIImageView(image: #imageLiteral(resourceName: "Ekran Resmi 2020-08-22 23.21.48"))
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        iv.addSubview(effect)
        effect.anchor(top: iv.topAnchor, left: iv.leftAnchor, bottom: iv.bottomAnchor, right: iv.rightAnchor, paddingRight: 40)
        UIView.animate(withDuration: 1.4, delay: 0, options: .curveEaseOut, animations: {
            effect.frame.origin.x = +400
        }) { (_) in
        }
        iv.contentMode = .scaleAspectFill
        vv.addSubview(iv)
        iv.fillSuperview()
        return vv
    }()
    
    
    private let createYourAccLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "Create \nyour account"
        label.alpha = 0
        return label
    }()
    
    
    private let emailTextField = CustomTextField(titleholder: "Email")
    private let fullnameTextField = CustomTextField(titleholder: "Full Name")
    private let passwordTextField = CustomTextField(titleholder: "Password", isSecureField: true)
    private let authButton: AuthButton = {
        let button = AuthButton(title: "Sign Up", type: .system, color: .white, backGroundColor: .black)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let toLogInButton: goToButton = {
        let button = goToButton(title: "Already have an account?", sTitle: "  Log In", type: .system)
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    private let secondaryAuth: AuthButton = {
        let button = AuthButton(title: "Sign up with Google", type: .system, color: .black, backGroundColor: .white)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureUI()
        configureTextFieldObservers()
        
    }
    
    // MARK: Selectors
    
    @objc func handleRegister() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        let credentials = AuthCredentials.init(email: email, password: password, fullname: fullname)
        
        AuthService.registerUser(withCredentials: credentials) { (err, ref) in
            if let err = err {
                print("Error signing up when pressed on register \(err.localizedDescription)")
            }
            //if no errors
            print("Successfully registered user")
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Service.fetchUser(withUid: uid) { (user) in
                let controller = RegistrationSecondaryController(user: user)
                controller.delegate = self.delegate
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else {
            viewModel.fullname = sender.text
        }
        
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.5061478019, green: 0.2849369943, blue: 0.2865973115, alpha: 1)
            authButton.setTitleColor(.white, for: .normal)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = .black
            authButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(firstView)
        firstView.anchor(top: view.topAnchor, left: view.leftAnchor,bottom: view.bottomAnchor, right: view.rightAnchor)
        
        let firstStack = UIStackView(arrangedSubviews: [emailTextField, fullnameTextField, passwordTextField, authButton, secondaryAuth])
        firstStack.axis = .vertical
        firstStack.spacing = 26
        view.addSubview(firstStack)
        firstStack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 62)
        firstStack.centerY(inView: view)
        
        view.addSubview(createYourAccLabel)
        createYourAccLabel.anchor(left: view.leftAnchor, bottom: firstStack.topAnchor, paddingLeft: 37, paddingBottom: 70)
        UIView.animate(withDuration: 1.2) {
            self.createYourAccLabel.frame.origin.y = +100
            self.createYourAccLabel.alpha = 1
        }
        
        view.addSubview(toLogInButton)
        toLogInButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 62)
        
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
}
