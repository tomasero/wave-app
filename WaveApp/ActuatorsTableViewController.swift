import UIKit
import CoreData

class ActuatorsTableViewController: UITableViewController {
    
    var actuatorList:Array<AnyObject> = []
    
    //returns list saved in CoreData
    func getList() -> Array<AnyObject> {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchReq = NSFetchRequest(entityName: "Actuator")
        return context.executeFetchRequest(fetchReq, error: nil)
    }
    //checks if item in coredata list already exists (has same name)
    func isInList(name: String) -> Bool {
        var list = getList()
        for item in list {
            if name == item.name {
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        actuatorList = getList()
        tableView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier? == "updateActuator" { //prevent nil segues
            var selectedActuator: NSManagedObject = actuatorList[self.tableView.indexPathForSelectedRow().row] as NSManagedObject
            let IVC: ActuatorViewController = segue.destinationViewController as ActuatorViewController
            IVC.name = selectedActuator.valueForKey("name") as? String //added ? after as --> as?
            IVC.pin = selectedActuator.valueForKey("pin") as? String
            IVC.existingActuator = selectedActuator
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return actuatorList.count
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cellID: NSString = "Cell"
        var cell: UITableViewCell = tableView?.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        if let ip = indexPath {
            var data: NSManagedObject = actuatorList[ip.row] as NSManagedObject
            cell.textLabel.text = data.valueForKeyPath("name") as String
            var pin = data.valueForKeyPath("pin") as String
            cell.detailTextLabel.text = "Pin: \(pin)"
        }
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let tv = tableView {
                context.deleteObject(actuatorList[indexPath!.row] as NSManagedObject)
                actuatorList.removeAtIndex(indexPath!.row)
                tv.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            var error: NSError? = nil
            if !context.save(&error) {
                abort()
            }
        }
    }
    
    @IBAction func backTapped(sender: AnyObject) {
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
