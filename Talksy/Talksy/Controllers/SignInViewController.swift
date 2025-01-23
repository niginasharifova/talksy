//
//  SignInViewController.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    // MARK: - Delegate
    var didFinishSignIn: (() -> Void)?
    
    // MARK: - UI elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.spacing = 22
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: UIScreen.main.bounds.size.height*0.09, right: 16)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    lazy var emailTextField = BaseTextField(form: TextFieldForm(title: "Почта", placeholder: "Введите почту", keyboardType: .emailAddress, required: true, readOnly: false, isSecureTextEntry: false))
    
    lazy var passwordTextField = BaseTextField(form: TextFieldForm(title: "Пароль", placeholder: "Введите пароль", keyboardType: .default, required: true, readOnly: false, isSecureTextEntry: true))
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .green500
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.green500, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(emailTextField)
        contentView.addArrangedSubview(passwordTextField)
        contentView.addArrangedSubview(signInButton)
        contentView.addArrangedSubview(signUpButton)
        
        scrollView.snp.makeConstraints { make in
          make.edges.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
          make.edges.centerX.equalTo(scrollView)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    @objc private func signInButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.getStringValue(),
              let password = passwordTextField.getStringValue(),
              !email.isEmpty,
              !password.isEmpty else {
            UIAlertController.showAlert(title: "Упс...", message: "Заполните все необходимые поля", vc: self)
            return
        }
        
        // log in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else {
                return
            }
            guard let result = result, error == nil else {
                print("Failed to log in")
                return
            }
            
            let user = result.user
            UserDefaults.standard.set(email, forKey: "email")
            
            self.didFinishSignIn?()
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func didTapRegister() {
        let vc = SignUpViewController()
        vc.title = "Регистрация"
        vc.didFinishSignUp = didFinishSignIn
        navigationController?.pushViewController(vc, animated: true)
    }
}
