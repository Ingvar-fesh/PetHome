import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .black
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.black.cgColor
        
        let profileController = ProfileViewController()
        let lentaController = LentaViewController()
        let createPostController = CreatePostViewController()
        
        
        profileController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(named: "account"),
            selectedImage: nil)
        
        lentaController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(named: "home"),
            selectedImage: nil)
        
        createPostController.tabBarItem = UITabBarItem(
            title: "Новый пост",
            image: UIImage(named: "add"),
            selectedImage: nil
        )
        
        let controllers = [
            lentaController,
            createPostController,
            profileController
        ]
        
        viewControllers = controllers
    }
}
