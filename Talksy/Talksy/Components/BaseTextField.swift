//
//  BaseTextField.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//

import UIKit

struct TextFieldForm {
    let title: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let required: Bool
    let readOnly: Bool
    let isSecureTextEntry: Bool
}

class BaseTextField: UIView {

    // MARK: - UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    lazy var textFieldBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .label
        textField.delegate = self
        textField.autocorrectionType = .no
        return textField
    }()

    // MARK: - Inits
    
    init(form: TextFieldForm) {
        super.init(frame: .zero)
        self.textField.keyboardType = form.keyboardType
        set(title: form.title)
        set(isReadOnly: form.readOnly)
        set(placeholder: form.placeholder)
        setSecureEntry(isSecureEntry: form.isSecureTextEntry)
        setupViews()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleTap() {
        textField.becomeFirstResponder()
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(textFieldBackground)
        textFieldBackground.addSubview(textField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldBackground.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(title: String) {
        titleLabel.text = title
        layoutIfNeeded()
    }
    
    func set(placeholder: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.black.withAlphaComponent(0.5)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    func set(isReadOnly: Bool) {
        textField.isEnabled = !isReadOnly
        if isReadOnly {
            textFieldBackground.alpha = 0.5
            titleLabel.alpha = 0.5
        }
    }
    
    func getStringValue() -> String? {
        textField.text
    }
    
    func setSecureEntry(isSecureEntry: Bool) {
        textField.isSecureTextEntry = isSecureEntry
    }
    
    // MARK: - Lifecycle
    override func updateConstraints() {
        let padding8 = CGFloat(8)
        let padding16 = CGFloat(16)
        let height48 = CGFloat(48)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            textFieldBackground.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding8),
            textFieldBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            textFieldBackground.heightAnchor.constraint(equalToConstant: height48),
            
            textField.topAnchor.constraint(equalTo: textFieldBackground.topAnchor),
            textField.bottomAnchor.constraint(equalTo: textFieldBackground.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldBackground.leadingAnchor, constant: padding16),
            textField.trailingAnchor.constraint(equalTo: textFieldBackground.trailingAnchor, constant: -padding16)
            ])
        super.updateConstraints()
    }
}

extension BaseTextField: UITextFieldDelegate {
    
}
