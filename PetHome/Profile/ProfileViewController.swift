import UIKit

final class ProfileViewController: UIViewController {
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 85
        image.backgroundColor = .gray
        return image
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 40
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return scrollView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nickname"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private lazy var postsInfo: CustomStack = {
        let posts = CustomStack(title: "Публикаций", amount: 0)
        posts.translatesAutoresizingMaskIntoConstraints = false
        return posts
    }()
    
    private lazy var followersInfo: CustomStack = {
        let followers = CustomStack(title: "Подписчиков", amount: 0)
        followers.translatesAutoresizingMaskIntoConstraints = false
        return followers
    }()
    
    private lazy var followingInfo: CustomStack = {
        let following = CustomStack(title: "Подписок", amount: 0)
        following.translatesAutoresizingMaskIntoConstraints = false
        return following
    }()
    
    private lazy var editProfileButton: UIButton = {
        let editProfileButton = UIButton(type: .custom)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.setTitle("Изменить", for: .normal)
        editProfileButton.setTitleColor(UIColor(named: "newYellow"), for: .normal)
        editProfileButton.backgroundColor = UIColor.white
        editProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        editProfileButton.titleLabel?.textColor = UIColor(named: "newYellow")
        editProfileButton.layer.cornerRadius = 16
        editProfileButton.layer.borderWidth = 2
        editProfileButton.layer.borderColor = UIColor(named: "newYellow")?.cgColor
        editProfileButton.frame.size = CGSize(width: 117, height: 33)
        return editProfileButton
    }()
    
    private lazy var messageButton: UIButton = {
        let messageButton = UIButton(type: .custom)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.setTitle("Сообщения", for: .normal)
        messageButton.setTitleColor(UIColor(named: "newYellow"), for: .normal)
        messageButton.backgroundColor = UIColor.white
        messageButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        messageButton.titleLabel?.textColor = UIColor(named: "newYellow")
        messageButton.layer.cornerRadius = 16
        messageButton.layer.borderWidth = 2
        messageButton.layer.borderColor = UIColor(named: "newYellow")?.cgColor
        messageButton.frame.size = CGSizeMake(117.0, 33.0)
        return messageButton
    }()
    
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var postCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.isScrollEnabled = true
        collection.isUserInteractionEnabled = true
        collection.alwaysBounceVertical = true
        collection.register(PostProfileCell.self, forCellWithReuseIdentifier: PostProfileCell.reuseIdentifier)
        return collection
    }()
    
    private var images: [UUID: UIImage] = [:]
    private let params = UICollectionView.GeometricParams(
        cellCount: 3,
        leftInset: 8,
        rightInset: 8,
        topInset: 13,
        bottomInset: 0,
        height: 150,
        cellSpacing: 7
    )
    
    private var nickName: String = ""
    private var postStore: PostStore? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "newBlue")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let userStore = appDelegate.userStore
        
        let defaults = UserDefaults.standard
        nickName = defaults.string(forKey: "userNickname")!
        
        nicknameLabel.text = nickName
        let user = userStore.getUserInfo(byNickname: nickName)
        profileImage.image = UIImage(data: (user?.profileImage)!)
        
        postStore = appDelegate.postStore
        let sortedPosts: [PostCoreData]? = postStore?.getPosts(forNickname: nickName).sorted {$0.createdAt! > $1.createdAt!}
        for post in sortedPosts! {
            images[post.id!] = UIImage(data: post.image!)
        }
        
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(profileImage)
        scrollView.addSubview(nicknameLabel)
        
        scrollView.addSubview(postsInfo)
        scrollView.addSubview(followersInfo)
        scrollView.addSubview(followingInfo)
        
        buttonStack.addArrangedSubview(editProfileButton)
        buttonStack.addArrangedSubview(messageButton)
        scrollView.addSubview(buttonStack)
        
        scrollView.addSubview(postCollectionView)
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        
        view.insertSubview(profileImage, aboveSubview: view)
        view.insertSubview(postCollectionView, aboveSubview: view)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 170),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileImage.heightAnchor.constraint(equalToConstant: 170),
            profileImage.widthAnchor.constraint(equalToConstant: 170),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -85),
            
            nicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12),
            
            followersInfo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            followersInfo.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 20),
            
            postsInfo.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            postsInfo.topAnchor.constraint(equalTo: followersInfo.topAnchor),
            
            followingInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            followingInfo.topAnchor.constraint(equalTo: followersInfo.topAnchor),
            
            editProfileButton.heightAnchor.constraint(equalToConstant: 33),
            editProfileButton.widthAnchor.constraint(equalToConstant: 117),
            
            messageButton.heightAnchor.constraint(equalToConstant: 33),
            messageButton.widthAnchor.constraint(equalToConstant: 117),
            
            buttonStack.topAnchor.constraint(equalTo: followersInfo.bottomAnchor, constant: 15),
            buttonStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            postCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            postCollectionView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 13),
            postCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            postCollectionView.heightAnchor.constraint(
                equalToConstant: (CGFloat(images.count) / params.cellCount * params.height + 18 + params.topInset + params.bottomInset) + 150
            ),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let userStore = appDelegate.userStore
        
        let defaults = UserDefaults.standard
        nickName = defaults.string(forKey: "userNickname")!
        
        nicknameLabel.text = nickName
        let user = userStore.getUserInfo(byNickname: nickName)
        profileImage.image = UIImage(data: (user?.profileImage)!)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        postStore = appDelegate.postStore
        let sortedPosts: [PostCoreData]? = postStore?.getPosts(forNickname: nickName).sorted {$0.createdAt! > $1.createdAt!}
        for post in sortedPosts! {
            images[post.id!] = UIImage(data: post.image!)
        }
        
        postCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.clipsToBounds = true
    }
}


extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostProfileCell.reuseIdentifier, for: indexPath) as? PostProfileCell else { return UICollectionViewCell() }
        let keys = Array(images.keys)
        if indexPath.item < keys.count {
            let key = keys[indexPath.item]
            if let image = images[key] {
                postCell.configure(with: image)
            }
        }
        return postCell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableSpace = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableSpace / params.cellCount
        return CGSize(width: cellWidth, height: params.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(
            top: params.topInset,
            left: params.leftInset,
            bottom: CGFloat(images.count) / params.cellCount * params.height + 18 + params.topInset + params.bottomInset,
            right: params.rightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keys = Array(images.keys)
        if indexPath.item < keys.count {
            let key = keys[indexPath.item]
            let vc = PostDetailsViewController(postId: key, creatorNickName: self.nickName)
            present(vc, animated: true)
        }
    }
}
