//
//  WayPointViewViewController.swift
//  Hone
//
//  Created by Joey Donino on 6/14/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

@available(iOS 8.0, *)
class WayPointViewViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var infoButton: UIButton!

    @IBOutlet weak var wayPointsTableView: UITableView!
    var selected: (Latitude: Double, Longitude: Double, title: String)?
    var selectedWP: WayPoint?
    
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(WayPointViewViewController.handleSwipe(_:)))
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
        slocationManager = CLLocationManager()
        slocationManager.requestWhenInUseAuthorization()
        slocationManager.delegate=self
        slocationManager.desiredAccuracy = kCLLocationAccuracyBest
        slocationManager.startUpdatingLocation()
     
        
    }
    
    
    @IBAction func backPressed(sender: UIButton) {
        performSegueWithIdentifier("backToMain", sender: self)

    }
    @IBAction func infoPressed(sender: UIButton) {
        let alerted2 = UIAlertController(title: "Waypoints", message: "Waypoints are simply a way to create custom coordinates that you can then 'Hone-In' on. Add a Waypoint by clicking the + in the upper right corner of the screen.  You can create a Waypoint from your current coordinates, or by dragging a pin to any coordinates on a map.  Enter a title and then click done to save the point.  Once saved, you can click on the blue arrow next to the title to start honing!", preferredStyle:.Alert)
        alerted2.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default,handler: nil))
        presentViewController(alerted2, animated: true, completion: nil)
        
        
        
        
    }
    override func viewDidAppear(animated: Bool) {


        
    }

    
    
    var slocationManager: CLLocationManager!
    
    func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .Ended{
            performSegueWithIdentifier("backToMain", sender: self)
            
        }
    }
    

    @IBOutlet weak var waypoints: UILabel!
    
    var locationValue: CLLocation?
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //println("did update location")
        locationValue=manager.location
        
    }
    
    
    @IBAction func addWaypoint(sender: UIButton) {

        let alert = UIAlertController(title: "Add Waypoint from:", message: nil, preferredStyle:.Alert)
        
        let currentLocationAction = UIAlertAction(title: "Current Location", style: .Default) {action -> Void in
            print("current")
            if self.slocationManager.location != nil {
                
                let wayPointObject: WayPoint = NSEntityDescription.insertNewObjectForEntityForName("WayPoint", inManagedObjectContext:  self.managedObjectContext!) as! WayPoint
                wayPointObject.created = NSDate()
                wayPointObject.latitude = NSNumber(double: (self.slocationManager.location?.coordinate.latitude)!)
                wayPointObject.longitude = NSNumber(double: (self.slocationManager.location?.coordinate.longitude)!)
                
                self.alertTitle(wayPointObject)
                do {
                       try self.managedObjectContext?.save()
                }catch {
                    
                }
                
                

            }else{
                let alertController = UIAlertController(title: "Sorry!", message:
                    "We cannot find your current location, please make sure Location Services are turned on", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            
                self.presentViewController(alertController, animated: true, completion: nil)

 
            }

        }
        let mapLocationAction = UIAlertAction(title: "Use Map", style: .Default) {action -> Void in
            self.performSegueWithIdentifier("toMapView", sender: self)
        }
        alert.addAction(currentLocationAction)
        alert.addAction(mapLocationAction)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func alertTitle(currentWay: WayPoint){
        
        var titleTextfield: UITextField?
    
        let alert = UIAlertController(title: "Title ", message: nil, preferredStyle:.Alert)
        let doneAction = UIAlertAction(title: "Done", style: .Default){ action -> Void in
            currentWay.title = titleTextfield!.text ?? ""
            do {
                try self.managedObjectContext?.save()
            }catch {
                
            }
            self.wayPointsTableView.reloadData()
            
            
        }
        
        alert.addTextFieldWithConfigurationHandler({(textfield: UITextField!) in
           titleTextfield = textfield
            if (currentWay.title == ""){
          titleTextfield!.placeholder = "Enter Title"
            }else{
              titleTextfield!.text = currentWay.title
            }
    
            })
        alert.addAction(doneAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    func getAllSaved() -> [WayPoint] {
        var savedWays = [WayPoint]()
        let entityDescription =
        NSEntityDescription.entityForName("WayPoint",
            inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        

        var objects: [AnyObject]?
        do {
            objects = try managedObjectContext?.executeFetchRequest(request)
        } catch _ as NSError {

            objects = nil
        }
        // println("objects are \(objects)")
        if let results = objects as? [WayPoint] {
            for result in results{
                savedWays.append(result)
            }
        }
        savedWays=savedWays.sort(sort)
        return savedWays
    }
    
    
    
 
    func sort(w1: WayPoint, w2: WayPoint) -> Bool{
        return w1.created.compare(w2.created) == .OrderedDescending
    }
    
    
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? MapViewController{
            if selectedWP != nil{
                vc.currentWayPoint = selectedWP!
            }
        }
        if let vc = segue.destinationViewController as? ViewController{
            if selected != nil{
               vc.wayPoint = (Double(selected!.Latitude), Double(selected!.Longitude), selected!.title)
            
           }
        }
        
    }
    
    
    func getObjectForTitle(title: String) -> WayPoint?{
        var wayObject: WayPoint?
        let wayTitle = title
        let entityDescription =
        NSEntityDescription.entityForName("WayPoint",
            inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        

        var objects: [AnyObject]?
        do {
            objects = try managedObjectContext?.executeFetchRequest(request)
        } catch _ as NSError {

            objects = nil
        }
        print("done selected3")
        if let results = objects as? [WayPoint]{
            print("done selected5")
            
            for result in results{
                if result.title == wayTitle{
                    wayObject = result
                }
                
            }
        }
        
        return wayObject
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
     

        
        return true
    }
    
    
    
    func honeButtonPressed(button: UIButton){
        let buttonview = button as UIView
        let wayPointcell = buttonview.superview?.superview as! WaypointTableCell
        let titleis = wayPointcell.wayObject?.title ?? ""
        selected = (Double((wayPointcell.wayObject?.latitude)!),Double((wayPointcell.wayObject?.longitude)!),titleis)
        self.performSegueWithIdentifier("backToMain", sender: self)
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = getAllSaved()
        return  results.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: WaypointTableCell = wayPointsTableView.dequeueReusableCellWithIdentifier("wayPointViewCell") as! WaypointTableCell

    
        cell.honeInButton.addTarget(self, action: #selector(WayPointViewViewController.honeButtonPressed(_:)), forControlEvents: UIControlEvents.AllTouchEvents)
        var results = getAllSaved()
        print(results)
        cell.wayObject = results[indexPath.row]
        cell.title.text = results[indexPath.row].title
        cell.coordinates.text = "\(results[indexPath.row].latitude), \(results[indexPath.row].longitude) "

        cell.userInteractionEnabled = true

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var results = getAllSaved()
        let selectedWaypoint = results[indexPath.row]
        if(selectedWaypoint.fromMap != 1){
        alertTitle(selectedWaypoint)
        }else{
        selectedWP = selectedWaypoint
        self.performSegueWithIdentifier("toMapView", sender: self)
        }
        
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var results = getAllSaved()
        if editingStyle == UITableViewCellEditingStyle.Delete {
            managedObjectContext?.deleteObject(results[indexPath.row])
            do {
                try managedObjectContext?.save()
            } catch _ as NSError {
                
            }

            results.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
    
    


}
