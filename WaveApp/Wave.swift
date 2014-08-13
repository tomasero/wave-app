import UIKit
import CoreData

var waveTypes: [Int: String] = [
    0: "Sine",
    1: "Saw",
    2: "Square",
    3: "Triangle",
    4: "Flat"
]

//make class available to obj-c : optional
@objc(Wave)
class Wave: NSManagedObject {
    
    //properties feeding the attributes in our entity must match the entity attributes
    @NSManaged var name: String
    @NSManaged var duration: String
    @NSManaged var period: String
    @NSManaged var minAmp: String
    @NSManaged var maxAmp: String
    @NSManaged var step: String
    @NSManaged var type: String
    
}
