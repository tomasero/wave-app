import UIKit
import CoreData

//make class available to obj-c : optional
@objc(Actuator)
class Actuator: NSManagedObject {
    
    //properties feeding the attributes in our entity must match the entity attributes
    @NSManaged var name: String
    @NSManaged var pin: String
    
    func toDictionary() -> [String:String] {
        return [
            "name": name,
            "pin": pin
        ]
    }
    
    func toJson() -> NSData! {
        var dictionary = self.toDictionary()
        var err: NSError?
        return NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions(0), error: &err)
    }
    
    func toJsonString() -> String! {
        return NSString(data: self.toJson(), encoding: NSUTF8StringEncoding)
    }
    
}
