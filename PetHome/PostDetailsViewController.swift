import UIKit

final class PostDetailsViewController: UIViewController {
    private lazy var leavePostButton: UIButton = {
        var leaveButton = UIButton(type: .custom)
        leaveButton.translatesAutoresizingMaskIntoConstraints = false
        leaveButton.backgroundColor = .white
        leaveButton.setImage(UIImage(named: "back"), for: .normal)
        leaveButton.addTarget(self, action: #selector(didTapLeaveButton), for: .touchUpInside)
        return leaveButton
    }()
    
    private lazy var creatorNicknameLabel: UILabel = {
        var nickName = UILabel()
        nickName.translatesAutoresizingMaskIntoConstraints = false
        nickName.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nickName.textColor = .black
        
        return nickName
    }()
    
    private lazy var creatorSmallImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = UIColor(named: "newRed")
        image.layer.cornerRadius = 40
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var upStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 9
        return stack
    }()
    
    private lazy var postScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray // Задаем начальный серый фон
        imageView.layer.cornerRadius = 60
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor(named: "newGray")?.cgColor
        button.layer.borderWidth = 3
        button.setImage(UIImage(named: "dislike"), for: .normal)
        button.setTitleColor(UIColor(named: "newGray"), for: .normal)
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15) // Измените значение в right на ваше усмотрение
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) // Измените значение в left на ваше усмотрение
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var postTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        
        return label
    }()
    
    private var postID: UUID
    private var creatorNickName: String
    private var postStore: PostStore? = nil
    private var userStore: UserStore? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        upStack.addArrangedSubview(leavePostButton)
        upStack.addArrangedSubview(creatorSmallImage)
        upStack.addArrangedSubview(creatorNicknameLabel)
        
        view.addSubview(upStack)
        
        postScrollView.addSubview(postImageView)
        postScrollView.addSubview(likeButton)
        postScrollView.addSubview(postTextLabel)
        postScrollView.addSubview(postDateLabel)
        
        view.addSubview(postScrollView)
        view.addSubview(postImageView)
        view.addSubview(likeButton)
        view.addSubview(postTextLabel)
        view.addSubview(postDateLabel)
        
        
        postScrollView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            upStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            upStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            creatorSmallImage.heightAnchor.constraint(equalToConstant: 40),
            creatorSmallImage.widthAnchor.constraint(equalToConstant: 40),
            
            
            postScrollView.topAnchor.constraint(equalTo: upStack.bottomAnchor, constant: 13),
            postScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            postScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            postImageView.topAnchor.constraint(equalTo: postScrollView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: postScrollView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 1.0),
            
            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 13),
            likeButton.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 100),
            likeButton.heightAnchor.constraint(equalToConstant: 45),
            
            postTextLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 18),
            postTextLabel.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor),
            postTextLabel.trailingAnchor.constraint(equalTo: postScrollView.trailingAnchor),
            
            postDateLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 5),
            postDateLabel.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor)
        ])
        
        let post = postStore?.getPostById(byID: self.postID)
        postImageView.image = UIImage(data: (post?.image)!)
        postTextLabel.text = post?.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        postDateLabel.text = dateFormatter.string(from: (post?.createdAt)!)
        
        let user = userStore?.getUserInfo(byNickname: creatorNickName)
        creatorNicknameLabel.text = creatorNickName
        creatorSmallImage.image = UIImage(data: (user?.profileImage)!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        creatorSmallImage.layer.cornerRadius = creatorSmallImage.bounds.width / 2
        creatorSmallImage.clipsToBounds = true
    }
    
    init(postId: UUID, creatorNickName: String) {
        self.postID = postId
        self.creatorNickName = creatorNickName
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        
        self.postStore = appDelegate.postStore
        self.userStore = appDelegate.userStore
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    func didTapLeaveButton() {
        dismiss(animated: false)
    }
    
    @objc
    func didTapLikeButton() {
        if likeButton.currentTitle == "0" {
            likeButton.layer.borderColor = UIColor(named: "newRed")?.cgColor
            likeButton.setImage(UIImage(named: "like"), for: .normal)
            likeButton.setTitleColor(UIColor(named: "newRed"), for: .normal)
            likeButton.setTitle("1", for: .normal)
        } else {
            likeButton.layer.borderColor = UIColor(named: "newGray")?.cgColor
            likeButton.setImage(UIImage(named: "dislike"), for: .normal)
            likeButton.setTitleColor(UIColor(named: "newGray"), for: .normal)
            likeButton.setTitle("0", for: .normal)
        }
    }
}
