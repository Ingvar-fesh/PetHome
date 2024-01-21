import UIKit


final class LentaPostCell: UITableViewCell {
    static let reuseIdentifier = "LentaPostCell"
    
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
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 60
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        contentView.backgroundColor = UIColor(named: "newBlue")
        upStack.addArrangedSubview(creatorSmallImage)
        upStack.addArrangedSubview(creatorNicknameLabel)
        contentView.addSubview(upStack)
        contentView.addSubview(postImageView)
        contentView.addSubview(postTextLabel)
        contentView.addSubview(postDateLabel)
        NSLayoutConstraint.activate([
            upStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            upStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            creatorSmallImage.heightAnchor.constraint(equalToConstant: 40),
            creatorSmallImage.widthAnchor.constraint(equalToConstant: 40),
            
            postImageView.topAnchor.constraint(equalTo: upStack.bottomAnchor, constant: 4),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 1.0),
            
            postTextLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 7),
            postTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            postDateLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 3),
            postDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creatorSmallImage.layer.cornerRadius = creatorSmallImage.bounds.width / 2
        creatorSmallImage.clipsToBounds = true
    }
    
    func configure(post: PostCoreData) {
        creatorSmallImage.image = UIImage(data: (post.author?.profileImage)!)
        creatorNicknameLabel.text = post.author?.nickname
        postImageView.image = UIImage(data: post.image!)
        postTextLabel.text = post.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        postDateLabel.text = dateFormatter.string(from: post.createdAt!)
    }
}
