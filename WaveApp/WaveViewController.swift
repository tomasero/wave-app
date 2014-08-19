import UIKit
import CoreData

class WaveViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtDuration: UITextField!
    @IBOutlet var txtPeriod: UITextField!
    @IBOutlet var txtMinAmp: UITextField!
    @IBOutlet var txtMaxAmp: UITextField!
    @IBOutlet var txtStep: UITextField!
    @IBOutlet var txtType: UITextField!
    var name: String?
    var duration: String?
    var period: String?
    var minAmp: String?
    var maxAmp: String?
    var step: String?
    var type: String?
    
    var existingWave: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if existingWave {
            txtName.text = name
            txtDuration.text = duration
            txtPeriod.text = period
            txtMinAmp.text = minAmp
            txtMaxAmp.text = maxAmp
            txtStep.text = step
            txtType.text = type
        }
        //This makes it so that textFieldShouldReturn works and the keyboard hides when the user clicks return
        txtName.delegate = self
        txtDuration.delegate = self
        txtPeriod.delegate = self
        txtMinAmp.delegate = self
        txtMaxAmp.delegate = self
        txtStep.delegate = self
        txtType.delegate = self
        
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        var saveSuccessful: Bool = false
        let wavesTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("WavesTableViewController") as WavesTableViewController
        if txtName.text == "" || txtDuration.text == "" || txtPeriod.text == "" || txtMinAmp.text == "" || txtMaxAmp.text == "" || txtStep.text == "" || txtType.text == "" {
            var alert: UIAlertView = UIAlertView()
            alert.title = "Errors"
            var message = String()
            if txtName.text == "" {
                message += "Name is empty\n"
            }
            if txtDuration.text == "" {
                message += "Duration is empty\n"
            }
            if txtPeriod.text == "" {
                message += "Period is empty\n"
            }
            if txtMinAmp.text == "" {
                message += "Min Amp is empty\n"
            }
            if txtMaxAmp.text == "" {
                message += "Max Amp is empty\n"
            }
            if txtStep.text == "" {
                message += "Step is empty\n"
            }
            if txtType.text == "" {
                message += "Type is empty\n"
            }
            alert.message = message
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            //Reference NSManaged object context
            
            let context: NSManagedObjectContext = appDel.managedObjectContext! //I unwrapped but tutorial didn't say that
            let entity = NSEntityDescription.entityForName("Wave", inManagedObjectContext: context)
            
            //Check if item exists
            
            if existingWave {
                //if new name is not the same as the previous
                //and the new name is not in the list
                if txtName.text != (existingWave as Wave).name && wavesTableViewController.isInList(txtName.text) {
                    var alert: UIAlertView = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Wave \(txtName.text) already exists"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    existingWave.setValue(txtName.text as String, forKey: "name")
                    existingWave.setValue(txtDuration.text as String, forKey: "duration")
                    existingWave.setValue(txtPeriod.text as String, forKey: "period")
                    existingWave.setValue(txtMinAmp.text as String, forKey: "minAmp")
                    existingWave.setValue(txtMaxAmp.text as String, forKey: "maxAmp")
                    existingWave.setValue(txtStep.text as String, forKey: "step")
                    existingWave.setValue(txtType.text as String, forKey: "type")
                    saveSuccessful = true
                }
            } else {
                if wavesTableViewController.isInList(txtName.text) {
                    var alert: UIAlertView = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Wave \(txtName.text) already exists"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                } else {
                    //Create instance of our data model and initialize
                    var newWave = Wave(entity: entity, insertIntoManagedObjectContext: context)
                    
                    //Map our properties
                    newWave.name = txtName.text
                    newWave.duration = txtDuration.text
                    newWave.period = txtPeriod.text
                    newWave.minAmp = txtMinAmp.text
                    newWave.maxAmp = txtMaxAmp.text
                    newWave.step = txtStep.text
                    newWave.type = txtType.text
                    existingWave = newWave
                    saveSuccessful = true
                }
            }
            if saveSuccessful {
                println((existingWave as Wave).toJsonString())
                context.save(nil)
                self.navigationController.pushViewController(wavesTableViewController, animated: false)
            }
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        //self.navigationController.popToRootViewControllerAnimated(true)
        let wavesTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("WavesTableViewController") as WavesTableViewController
        self.navigationController.pushViewController(wavesTableViewController, animated: false)
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
