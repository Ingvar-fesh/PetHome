import UIKit

final class AuthViewController: UIViewController, UITextFieldDelegate {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "big-home")
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PetHome"
        label.font = UIFont(name: "Marker Felt Thin", size: 45)
        label.sizeToFit()
        label.textColor = .black
        return label
    }()
    
    private lazy var stackView1: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Логин"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пароль"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var loginField: UITextField = {
        let textField = TextField(placeholder: "Введите логин")
//        textField.addTarget(self, action: #selector(didChangedLabelTextField), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = TextField(placeholder: "Введите пароль")
//        textField.addTarget(self, action: #selector(didChangedLabelTextField), for: .editingChanged)
        return textField
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "newYellow")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.borderColor = UIColor(named: "newYellow")?.cgColor
        button.addTarget(self, action: #selector(didRegistrayionEvent), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 32
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        stackView1.addArrangedSubview(imageView)
        stackView1.addArrangedSubview(titleLabel)
        
        buttonStackView.addArrangedSubview(enterButton)
        buttonStackView.addArrangedSubview(registrationButton)
        
        view.addSubview(stackView1)
        view.addSubview(loginLabel)
        view.addSubview(loginField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 83),
            imageView.heightAnchor.constraint(equalToConstant: 83),
            
            stackView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            stackView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 50),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            
            loginField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 3),
            loginField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            loginField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -31),
            loginField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 25),
            passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 3),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -31),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            enterButton.heightAnchor.constraint(equalToConstant: 50),
            enterButton.widthAnchor.constraint(equalToConstant: 148),
            
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            registrationButton.widthAnchor.constraint(equalToConstant: 148),
            
            buttonStackView.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loginField.delegate = self
        passwordField.delegate = self
    }
    
    @objc
    func didRegistrayionEvent() {
        let registrationController = RegistrationViewController()
        present(registrationController, animated: true)
    }
    
    @objc
    func didTapEnterButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let userStore = appDelegate.userStore
        
        let (nickname, password) = userStore.getUserData(forLogin: loginField.text!)
        if nickname == nil && password == nil {
            let alert = UIAlertController(title: "Ошибка", message: "Такого пользователя нет", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else if passwordField.text != password {
            let alert = UIAlertController(title: "Ошибка", message: "Нерпавильно введен пароль", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            let defaults = UserDefaults.standard
            defaults.set(nickname, forKey: "userNickname")
            dismiss(animated: true)
            let tabBar = TabBarViewController()
            present(tabBar, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
