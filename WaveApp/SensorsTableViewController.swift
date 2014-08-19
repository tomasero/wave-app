import UIKit
import CoreData

class SensorsTableViewController: UITableViewController {
    
    var sensorList:Array<AnyObject> = []
    
    //returns list saved in CoreData
    func getList() -> Array<AnyObject> {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchReq = NSFetchRequest(entityName: "Sensor")
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
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchReq = NSFetchRequest(entityName: "Sensor")
        
        sensorList = context.executeFetchRequest(fetchReq, error: nil)
        tableView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier? == "updateSensor" { //prevent nil segues
            var selectedSensor: NSManagedObject = sensorList[self.tableView.indexPathForSelectedRow().row] as NSManagedObject
            let IVC: SensorViewController = segue.destinationViewController as SensorViewController
            IVC.name = selectedSensor.valueForKey("name") as? String //added ? after as --> as?
            IVC.pin = selectedSensor.valueForKey("pin") as? String
            IVC.sensitivity = selectedSensor.valueForKey("sensitivity") as? String
            IVC.existingSensor = selectedSensor
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
        return sensorList.count
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cellID: NSString = "Cell"
        var cell: UITableViewCell = tableView?.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        if let ip = indexPath {
            var data: Sensor = sensorList[ip.row] as Sensor
            cell.textLabel.text = data.valueForKeyPath("name") as String
            var pin = data.valueForKeyPath("pin") as String
            var sensitivity = data.valueForKeyPath("sensitivity") as String
            cell.detailTextLabel.text = "Pin: \(pin) | Sensitivity: \(sensitivity)"
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
                context.deleteObject(sensorList[indexPath!.row] as NSManagedObject)
                sensorList.removeAtIndex(indexPath!.row)
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
