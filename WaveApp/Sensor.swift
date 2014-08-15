import UIKit
import CoreData

//make class available to obj-c : optional
@objc(Sensor)
class Sensor: NSManagedObject {
    
    //properties feeding the attributes in our entity must match the entity attributes
    @NSManaged var name: String
    @NSManaged var pin: String
    @NSManaged var sensitivity: String
    
    func toDictionary() -> [String:String] {
        return [
            "name": name,
            "pin": pin,
            "sensitivity": sensitivity
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
