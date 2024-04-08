import Foundation
import CoreData
import UIKit
class CoreDataManager {

    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataLessonN1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
        
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func createTask(name: String, deadline: Date) {
        let context = persistentContainer.viewContext
        let task = ToDoListTask(context: context)
        task.deadline = deadline
        task.name = name
        task.isDone = false
        saveContext()
    }
    
    func getTasks() -> [ToDoListTask] {
        let context = persistentContainer.viewContext
        let request = ToDoListTask.fetchRequest()
        do {
            let tasks = try context.fetch(request)
            return tasks
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func updateTask(task: ToDoListTask) {
        task.isDone.toggle()
        saveContext()
    }
    
    func deleteTask(task: ToDoListTask) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }

}
