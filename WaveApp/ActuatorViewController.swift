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
        //Reference to our app delegate
        println(txtName.text)
        if txtName.text == "" || txtPin.text == "" {
            var alert: UIAlertView = UIAlertView()
            alert.title = "Errors"
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
            let entity = NSEntityDescription.entityForName("Actuators", inManagedObjectContext: context)
            
            //Check if item exists
            
            if existingActuator {
                existingActuator.setValue(txtName.text as String, forKey: "name")
                existingActuator.setValue(txtPin.text as String, forKey: "pin")
            } else {
                //Create instance of our data model and initialize
                var newActuator = Actuator(entity: entity, insertIntoManagedObjectContext: context)
                
                //Map our properties
                newActuator.name = txtName.text
                newActuator.pin = txtPin.text
            }
            
            //Save our context
            context.save(nil)
            
            //navigate back to root vc
            //self.navigationController.popToRootViewControllerAnimated(true)
            let actuatorsTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("ActuatorsTableViewController") as ActuatorsTableViewController
            self.navigationController.pushViewController(actuatorsTableViewController, animated: false)
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
