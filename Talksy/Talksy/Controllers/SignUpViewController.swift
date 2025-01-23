//
//  SignUpViewController.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//

import UIKit
import SnapKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Delegate
    var didFinishSignUp: (() -> Void)?
    
    // MARK: - UI elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let contentView: UIStackView = {
        let view = UIStackView()
        view.spacing = 22
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: UIScreen.main.bounds.size.height*0.09, right: 16)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameTextField = BaseTextField(form: TextFieldForm(title: "Имя", placeholder: "Введите имя", keyboardType: .default, required: true, readOnly: false, isSecureTextEntry: false))
    
    private let surnameTextField = BaseTextField(form: TextFieldForm(title: "Фамилия", placeholder: "Введите фамилию", keyboardType: .default, required: true, readOnly: false, isSecureTextEntry: false))
    
    private let emailTextField = BaseTextField(form: TextFieldForm(title: "Почта", placeholder: "Введите почту", keyboardType: .emailAddress, required: true, readOnly: false, isSecureTextEntry: false))
    
    private let passwordTextField = BaseTextField(form: TextFieldForm(title: "Пароль", placeholder: "Введите пароль", keyboardType: .default, required: true, readOnly: false, isSecureTextEntry: true))
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .green500
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(imageView)
        contentView.addArrangedSubview(nameTextField)
        contentView.addArrangedSubview(surnameTextField)
        contentView.addArrangedSubview(emailTextField)
        contentView.addArrangedSubview(passwordTextField)
        contentView.addArrangedSubview(signUpButton)
        
        scrollView.snp.makeConstraints { make in
          make.edges.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
          make.edges.centerX.equalTo(scrollView)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
    }
    
    @objc private func signUpButtonTapped() {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
                
        guard let name = nameTextField.getStringValue(),
              let surname = surnameTextField.getStringValue(),
              let email = emailTextField.getStringValue(),
              let password = passwordTextField.getStringValue(),
              !name.isEmpty, !surname.isEmpty, !email.isEmpty, !password.isEmpty else {
            UIAlertController.showAlert(title: "Упс...", message: "Заполните все необходимые поля", vc: self)
            return
        }


        // Firebase Log In
        DataBaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let self = self else {
                return
            }

            guard !exists else {
                // user already exists
                UIAlertController.showAlert(title: "Упс...", message: "Аккаунт с таким адресом уже существует", vc: self)
                return
            }

            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    return
                }

                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue("\(name) \(surname)", forKey: "name")


                let chatUser = AppUser(firstName: name,
                                       lastName: surname,
                                       emailAddress: email)
                DataBaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // upload image
                        guard let image = self.imageView.image,
                            let data = image.pngData() else {
                                return
                        }
                        let filename = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        })
                    }
                })

                self.didFinishSignUp?()
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentCamera()

        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        self.imageView.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
