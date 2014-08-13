import UIKit
import CoreData

//make class available to obj-c : optional
@objc(Actuator)
class Actuator: NSManagedObject {
    
    //properties feeding the attributes in our entity must match the entity attributes
    @NSManaged var name: String
    @NSManaged var pin: String
    
}
