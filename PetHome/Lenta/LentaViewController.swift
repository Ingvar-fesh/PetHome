import UIKit

final class LentaViewController: UIViewController {
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "big-home")
        return image
    }()
    
    private lazy var mainTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "PetHome"
        title.font = UIFont(name: "Marker Felt Thin", size: 34)
        title.sizeToFit()
        title.textColor = .black
        return title
    }()
    
    private lazy var upStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 7
        return stack
    }()
    
    private lazy var postsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor(named: "newBlue")
        table.isScrollEnabled = true
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private var postStore: PostStore? = nil
    private var posts: [PostCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "newBlue")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let postStore = appDelegate.postStore
        
        view.addSubview(upStack)
        upStack.addArrangedSubview(iconImage)
        upStack.addArrangedSubview(mainTitle)
        
        postsTableView.register(LentaPostCell.self, forCellReuseIdentifier: LentaPostCell.reuseIdentifier)
        postsTableView.dataSource = self
        view.addSubview(postsTableView)
        
        NSLayoutConstraint.activate([
            upStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            upStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            mainTitle.bottomAnchor.constraint(equalTo: upStack.bottomAnchor, constant: 20),
            iconImage.widthAnchor.constraint(equalToConstant: 73),
            iconImage.heightAnchor.constraint(equalToConstant: 66),
            
            postsTableView.topAnchor.constraint(equalTo: upStack.bottomAnchor, constant: 12),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        posts = postStore.getAllPosts().sorted {$0.createdAt! > $1.createdAt!}
        postsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        let postStore = appDelegate.postStore
        posts = postStore.getAllPosts().sorted {$0.createdAt! > $1.createdAt!}
        postsTableView.reloadData()
    }
}

extension LentaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LentaPostCell.reuseIdentifier, for: indexPath) as! LentaPostCell
        let post = posts[indexPath.row]
        cell.configure(post: post)
        return cell
    }
}

extension LentaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height - 50
    }
}
