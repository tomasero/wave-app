import UIKit
import CoreData

class ActuatorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPin: UITextField!
    var name: String?
    var pin: String?
    
    var existingActuator: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if existingActuator {
            txtName.text = name
            txtPin.text = pin
        }
        //This makes it so that textFieldShouldReturn works and the keyboard hides when the user clicks return
        txtName.delegate = self
        txtPin.delegate = self
        
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        var saveSuccessful: Bool = false
        let actuatorsTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("ActuatorsTableViewController") as ActuatorsTableViewController
        if txtName.text == "" || txtPin.text == "" {
            var alert: UIAlertView = UIAlertView()
            alert.title = "Error"
            var message = String()
            if txtName.text == "" {
                message += "Name is empty\n"
            }
            if txtPin.text == "" {
                message += "Duration is empty\n"
            }
            alert.message = message
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            //Reference NSManaged object context
            
            let context: NSManagedObjectContext = appDel.managedObjectContext! //I unwrapped but tutorial didn't say that
            let entity = NSEntityDescription.entityForName("Actuator", inManagedObjectContext: context)
            
            //Check if item exists
            
            if existingActuator {
                //if new name is not the same as the previous
                //and the new name is not in the list
                if txtName.text != (existingActuator as Actuator).name && actuatorsTableViewController.isInList(txtName.text) {
                    var alert: UIAlertView = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Actuator \(txtName.text) already exists"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    existingActuator.setValue(txtName.text as String, forKey: "name")
                    existingActuator.setValue(txtPin.text as String, forKey: "pin")
                    saveSuccessful = true
                }
            } else {
                //checks of name already exists
                if actuatorsTableViewController.isInList(txtName.text) {
                    var alert: UIAlertView = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Actuator \(txtName.text) already exists"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    //Create instance of our data model and initialize
                    var newActuator = Actuator(entity: entity, insertIntoManagedObjectContext: context)
                    newActuator.name = txtName.text
                    newActuator.pin = txtPin.text
                    println("newActuator: \(newActuator.name)")
                    existingActuator = newActuator
                    saveSuccessful = true
                }
            }
            if saveSuccessful {
                println((existingActuator as Actuator).toJsonString())
                context.save(nil)
                self.navigationController.pushViewController(actuatorsTableViewController, animated: false)
            }
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        //self.navigationController.popToRootViewControllerAnimated(true)
        let actuatorsTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("ActuatorsTableViewController") as ActuatorsTableViewController
        self.navigationController.pushViewController(actuatorsTableViewController, animated: false)
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
