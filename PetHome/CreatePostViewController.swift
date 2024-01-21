import UIKit

final class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание поста"
        label.font = UIFont(name: "Marker Felt Thin", size: 32)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray // Задаем начальный серый фон
        imageView.layer.cornerRadius = 60
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textView: ExpandableTextView = {
        let textView = ExpandableTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "newYellow")
        button.layer.cornerRadius = 16
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(UIColor(named: "newRed"), for: .normal)
        button.setTitle("Отменить", for: .normal)
        button.layer.borderColor = UIColor(named: "newRed")?.cgColor
        button.layer.borderWidth = 3
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 30
        return stack
    }()
    
    let imagePicker = UIImagePickerController()
    private var nickName = ""
    private var userStore: UserStore? = nil
    private var postStore: PostStore? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        
        userStore = appDelegate.userStore
        postStore = appDelegate.postStore
        
        let defaults = UserDefaults.standard
        nickName = defaults.string(forKey: "userNickname")!
        
        setupViews()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.backgroundColor = .lightGray
        textView.text = nil
    }
    
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(imageView)
        
        view.addSubview(textView)
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(createButton)
        
        view.addSubview(buttonStack)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 4 * view.frame.width / 5),
            imageView.heightAnchor.constraint(equalToConstant: 4 * view.frame.width / 5),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            buttonStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 25),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 148),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            createButton.widthAnchor.constraint(equalToConstant: 148),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc 
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = pickedImage
            imageView.backgroundColor = .clear
        }
        
        dismiss(animated: true, completion: nil)
    }
        
    @objc 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapCreateButton() {
        if imageView.image == nil || textView.text == nil {
            let alert = UIAlertController(title: "Ошибка", message: "Не добавлена картинка или не введен текст", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            postStore?.addPost(id: UUID(), text: textView.text, image: (imageView.image?.pngData())!, nickname: nickName, createdAt: Date())
            tabBarController?.selectedIndex = 2
        }
    }
}
