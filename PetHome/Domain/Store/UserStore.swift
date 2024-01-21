import UIKit
import CoreData

final class UserStore {
    private let context: NSManagedObjectContext
        
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
    // Добавление нового пользователя в базу данных
    func addUser(nickname: String, profileImage: Data, login: String, password: String) {
        let newUser = UserCoreData(context: context)
        newUser.nickname = nickname
        newUser.profileImage = profileImage
        newUser.login = login
        newUser.password = password
        
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении пользователя: \(error.localizedDescription)")
        }
    }
    
    // Удаление пользователя по его никнейму
    func deleteUser(byNickname nickname: String) {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", nickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                context.delete(user)
                try context.save()
            }
        } catch {
            print("Ошибка при удалении пользователя: \(error.localizedDescription)")
        }
    }
    
    // Добавление нового подписчика для данного пользователя
    func addFollower(followerNickname: String, forUserWithNickname userNickname: String) {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", userNickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                let follower = UserCoreData(context: context)
                follower.nickname = followerNickname
                user.addToFollowers(follower)
                try context.save()
            }
        } catch {
            print("Ошибка при добавлении подписчика: \(error.localizedDescription)")
        }
    }
    
    // Добавление подписки по никнейму пользователя
    func addSubscription(subscriberNickname: String, forUserWithNickname userNickname: String) {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", userNickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                let subscriber = UserCoreData(context: context)
                subscriber.nickname = subscriberNickname
                user.addToFollowing(subscriber)
                try context.save()
            }
        } catch {
            print("Ошибка при добавлении подписки: \(error.localizedDescription)")
        }
    }
    
    // Получение всех подписчиков для пользователя с указанным никнеймом
    func getAllFollowers(forUserWithNickname userNickname: String) -> [UserCoreData] {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", userNickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first, let followers = user.followers?.allObjects as? [UserCoreData] {
                return followers
            }
        } catch {
            print("Ошибка при получении подписчиков: \(error.localizedDescription)")
        }
        return []
    }
    
    // Получение всех подписок для пользователя с указанным никнеймом
    func getAllSubscriptions(forUserWithNickname userNickname: String) -> [UserCoreData] {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", userNickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first, let subscriptions = user.following?.allObjects as? [UserCoreData] {
                return subscriptions
            }
        } catch {
            print("Ошибка при получении подписок: \(error.localizedDescription)")
        }
        return []
    }
    
    // Поиск пользователя по логину и получение пароля и nickname, если он существует
    func getUserData(forLogin login: String) -> (password: String?, nickname: String?) {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                let password = user.password
                let nickname = user.nickname
                return (nickname, password)
            }
        } catch {
            print("Ошибка при поиске пользователя: \(error.localizedDescription)")
        }
        return (nil, nil)
    }
    
    func getUserInfo(byNickname nickname: String) -> UserCoreData? {
        let fetchRequest: NSFetchRequest<UserCoreData> = UserCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", nickname)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first // Возвращает первого пользователя с указанным никнеймом
        } catch {
            print("Ошибка при получении информации о пользователе: \(error.localizedDescription)")
        }
        return nil
    }
}
