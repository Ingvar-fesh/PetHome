import UIKit
import CoreData

final class PostStore {
    private let context: NSManagedObjectContext
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
    func addPost(id: UUID,text: String, image: Data, nickname: String, createdAt: Date) {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", nickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            guard let user = users.first else {
                print("Пользователь с nickname '\(nickname)' не найден")
                return
            }
            
            let newPost = PostCoreData(context: context)
            newPost.id = id
            newPost.text = text
            newPost.createdAt = createdAt
            newPost.image = image
            newPost.author = user
            
            try context.save()
        } catch {
            print("Ошибка при добавлении поста: \(error.localizedDescription)")
        }
    }
    
    func getPosts(forNickname nickname: String) -> [PostCoreData] {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", nickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                return user.posts?.allObjects as? [PostCoreData] ?? []
            }
        } catch {
            print("Ошибка при получении постов: \(error.localizedDescription)")
        }
        return []
    }
    
    func deletePost(_ post: PostCoreData) {
        context.delete(post)
        
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении поста: \(error.localizedDescription)")
        }
    }
    
    func getPostById(byID postID: UUID) -> PostCoreData? {
        let fetchRequest: NSFetchRequest<PostCoreData> = PostCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", postID as CVarArg)
        
        do {
            let posts = try context.fetch(fetchRequest)
            return posts.first // Возвращает первый пост с указанным ID
        } catch {
            print("Ошибка при получении поста: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getAllPosts() -> [PostCoreData] {
        let fetchRequest: NSFetchRequest<PostCoreData> = PostCoreData.fetchRequest()
        
        do {
            let posts = try context.fetch(fetchRequest)
            return posts // Возвращает массив всех постов всех пользователей
        } catch {
            print("Ошибка при получении всех постов: \(error.localizedDescription)")
            return [] // Возвращает пустой массив при возникновении ошибки
        }
    }
}
