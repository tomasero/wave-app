import UIKit
import CoreData

class WavesTableViewController: UITableViewController {
    
    var waveList:Array<AnyObject> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchReq = NSFetchRequest(entityName: "Wave")
        
        waveList = context.executeFetchRequest(fetchReq, error: nil)
        tableView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier? == "updateWave" { //prevent nil segues
            var selectedWave: NSManagedObject = waveList[self.tableView.indexPathForSelectedRow().row] as NSManagedObject
            let IVC: WaveViewController = segue.destinationViewController as WaveViewController
            IVC.name = selectedWave.valueForKey("name") as? String //added ? after as --> as?
            IVC.duration = selectedWave.valueForKey("duration") as? String
            IVC.period = selectedWave.valueForKey("period") as? String
            IVC.minAmp = selectedWave.valueForKey("minAmp") as? String
            IVC.maxAmp = selectedWave.valueForKey("maxAmp") as? String
            IVC.step = selectedWave.valueForKey("step") as? String
            IVC.type = selectedWave.valueForKey("type") as? String
            IVC.existingWave = selectedWave
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
        return waveList.count
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cellID: NSString = "Cell"
        var cell: UITableViewCell = tableView?.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        if let ip = indexPath {
            var data: NSManagedObject = waveList[ip.row] as NSManagedObject
            cell.textLabel.text = data.valueForKeyPath("name") as String
            var type = data.valueForKeyPath("type") as String
            var minAmp = data.valueForKeyPath("minAmp") as String
            var maxAmp = data.valueForKeyPath("maxAmp") as String
            
            cell.detailTextLabel.text = "\(waveTypes[type.toInt()!]!) - [\(minAmp):\(maxAmp)]"
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
                context.deleteObject(waveList[indexPath!.row] as NSManagedObject)
                waveList.removeAtIndex(indexPath!.row)
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
