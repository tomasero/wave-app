import UIKit
import CoreData

class SensorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPin: UITextField!
    @IBOutlet var txtSensitivity: UITextField!
    var name: String?
    var pin: String?
    var sensitivity: String?
    
    var existingSensor: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if existingSensor {
            txtName.text = name
            txtPin.text = pin
            txtSensitivity.text = sensitivity
        }
        //This makes it so that textFieldShouldReturn works and the keyboard hides when the user clicks return
        txtName.delegate = self
        txtPin.delegate = self
        txtSensitivity.delegate = self
        
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        var saveSuccessful: Bool = false
        let sensorsTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("SensorsTableViewController") as SensorsTableViewController
        if txtName.text == "" || txtPin.text == "" || txtSensitivity.text == "" {
            var alert: UIAlertView = UIAlertView()
            alert.title = "Errors"
            var message = String()
            if txtName.text == "" {
                message += "Name is empty\n"
            }
            if txtPin.text == "" {
                message += "Duration is empty\n"
            }
            if txtSensitivity.text == "" {
                message += "Sensitivity is empty\n"
            }
            alert.message = message
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            //Reference NSManaged object context
            
            let context: NSManagedObjectContext = appDel.managedObjectContext! //I unwrapped but tutorial didn't say that
            let entity = NSEntityDescription.entityForName("Sensor", inManagedObjectContext: context)
            
            //Check if item exists
            
            if existingSensor {
                //if new name is not the same as the previous
                //and the new name is not in the list
                if txtName.text != (existingSensor as Sensor).name && sensorsTableViewController.isInList(txtName.text) {
                    var alert: UIAlertView = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Sensor \(txtName.text) already exists"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    existingSensor.setValue(txtName.text as String, forKey: "name")
                    existingSensor.setValue(txtPin.text as String, forKey: "pin")
                    existingSensor.setValue(txtSensitivity.text as String, forKey: "sensitivity")
                    saveSuccessful = true
                }
            } else {
                //checks of name already exists
                if sensorsTableViewController.isInList(txtName.text) {
                    var alert: UIAlertView = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Sensor \(txtName.text) already exists"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    //Create instance of our data model and initialize
                    var newSensor = Sensor(entity: entity, insertIntoManagedObjectContext: context)
                    
                    //Map our properties
                    newSensor.name = txtName.text
                    newSensor.pin = txtPin.text
                    newSensor.sensitivity = txtSensitivity.text
                    existingSensor = newSensor
                    saveSuccessful = true
                }
                
            }
            if saveSuccessful {
                println((existingSensor as Sensor).toJsonString())
                context.save(nil)
                self.navigationController.pushViewController(sensorsTableViewController, animated: false)
            }
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        //self.navigationController.popToRootViewControllerAnimated(true)
        let sensorsTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("SensorsTableViewController") as SensorsTableViewController
        self.navigationController.pushViewController(sensorsTableViewController, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //iOS Touch Functions
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    //UITextField Delegate
    //Hide keyboard when click return
    //Not working before, fixed it by setting delegates to self in viewDidLoad
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
