import UIKit

final class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.layer.cornerRadius = 85
        profileImage.contentMode = .scaleAspectFit
        profileImage.backgroundColor = .lightGray // Задаем начальный серый фон
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Имя пользователя"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var nicknameField: UITextField = {
        let textField = TextField(placeholder: "Введите имя пользователя")
        return textField
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Логин"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var loginField: UITextField = {
        let textField = TextField(placeholder: "Введите логин")
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пароль"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = TextField(placeholder: "Введите пароль")
        return textField
    }()
    
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "newYellow")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(profileImage)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameField)
        view.addSubview(loginLabel)
        view.addSubview(loginField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 170),
            profileImage.widthAnchor.constraint(equalToConstant: 170),
            
            nicknameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            
            nicknameField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 3),
            nicknameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            nicknameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -31),
            nicknameField.heightAnchor.constraint(equalToConstant: 50),
            
            loginLabel.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 21),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            
            loginField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 3),
            loginField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            loginField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -31),
            loginField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 21),
            passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 3),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -31),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.widthAnchor.constraint(equalToConstant: 148),
            ])
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        nicknameField.delegate = self
        loginField.delegate = self
        passwordField.delegate = self
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        let alert = UIAlertController(title: "Добавить изображение", message: nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            self.openGallery()
        }
        
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.openCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Камера недоступна", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
    func didTapCreateButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let userStore = appDelegate.userStore
        userStore.addUser(nickname: nicknameField.text ?? "",
                          profileImage: profileImage.image?.pngData() ?? Data(),
                          login: loginField.text ?? "",
                          password: passwordField.text ?? "")
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           profileImage.contentMode = .scaleAspectFill
           profileImage.image = pickedImage
           profileImage.layer.cornerRadius = profileImage.frame.width / 2 // Превращаем изображение в круг
           profileImage.clipsToBounds = true
       }
       dismiss(animated: true, completion: nil)
   }
}
