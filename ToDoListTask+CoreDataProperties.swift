import Foundation
import CoreData


extension ToDoListTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListTask> {
        return NSFetchRequest<ToDoListTask>(entityName: "ToDoListTask")
    }

    @NSManaged public var name: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var isDone: Bool

}

extension ToDoListTask : Identifiable {

}
