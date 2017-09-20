//
//  ViewController.swift
//  Hone
//
//  Created by Joey Donino on 6/9/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import QuartzCore

@available(iOS 8.0, *)
class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var cardinalDirections: UIImageView!
    var locationManager: CLLocationManager!
    var searchResultList=[String]()
    var mapItemsList=[MKMapItem]()
    var wayPoint: (Latitude: Double, Longitude: Double, Title: String)?
    var locationAlert: Bool = false
    var results: [(String, String, String, MKMapItem)] = []
    var tapgest: UITapGestureRecognizer?


    func homeButtonPressed(sender: UIButton) {
        let urlPath: String = "http://localhost:9080"
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{  (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var jsonResult: NSDictionary?
            if let datab = data{
                
            
            do {
           jsonResult = try NSJSONSerialization.JSONObjectWithData(datab, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            print(jsonResult)
            } catch let caught as NSError {
             print(caught)
            }
            }
        })
        
        
    }
    
    
   func contactPressed(sender: UIButton) {
        print("contact pressed")
        let urlPath: String = "http://localhost:9080"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "post"
        let params = ["username":"jameson", "password":"password"] as Dictionary<String, String>
      
        do{
        try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        }catch let error{
            print(error)
        }
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            do{
            _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            }catch let err{
                print(err)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        
        })
        task.resume()
        
        
        
    }
    
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var arrow: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.allowsSelection = true
        //searchTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "result")
      
        locationAlert = false
        locationManager=CLLocationManager()
               locationManager.requestWhenInUseAuthorization()
   
        locationManager.delegate=self
        searchField.delegate=self
        
        locationManager.startUpdatingHeading()
        //arrow.layer.anchorPoint=cardinalDirections.center;
        arrow.hidden=true;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.suggest), name: UITextFieldTextDidChangeNotification, object: self.searchField)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.suggest), name: UITextFieldTextDidBeginEditingNotification, object: self.searchField)
        let tap=UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        tapgest = tap
    
        tap.delegate=self
        backGroundView.addGestureRecognizer(tap)
        let swipe=UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipe(_:)))
        swipe.direction = .Right
        swipe.delegate=self
        backGroundView.addGestureRecognizer(swipe)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if locationManager.location == nil {
            
                let alertController = UIAlertController(title: "Sorry!", message:
                    "We cannot find your current location, please make sure Location Services are turned on", preferredStyle: UIAlertControllerStyle.Alert)
   
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        if let _ = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched")
            
            
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            
            print("App launched first time")
            let alertController = UIAlertController(title: "Controls", message:
                "Swipe right to access Waypoints", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default,handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        
        if wayPoint != nil {
            print("waypoint")
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(wayPoint!.Latitude, wayPoint!.Longitude)
            
            let wayPlace = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let wayItem = MKMapItem(placemark: wayPlace)
            wayItem.name = wayPoint!.Title
            currentMapItem = wayItem
            setDisplay(currentMapItem!)
        }
        
        
        locationManagerShouldDisplayHeadingCalibration(self.locationManager)
        
        
        
    }
    

    
    @IBOutlet weak var honeButton: UIButton!
    @IBOutlet weak var suggestionView1: SearchSuggestionView!
    var heading = 0.0
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let degrees=(newHeading.trueHeading as Double)*M_PI/180
        heading = degrees
        UIView.animateWithDuration(NSTimeInterval(0.4), animations: {
        self.cardinalDirections.transform=CGAffineTransformMakeRotation(CGFloat(-degrees))
            })
        if let item = currentMapItem{
        setDisplay(item)
        }
        
        
        
    }
    @IBOutlet weak var HoneName: UILabel!
    
    
    @IBOutlet weak var HoneDistance: UILabel!
    var locationValue: CLLocationCoordinate2D?
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("did update location")
        locationValue=manager.location!.coordinate
        //print("\(locationValue)")
        if let mapItemExists=currentMapItem{
        setDisplay(mapItemExists)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    var currentMapItem:MKMapItem?
    
    func handleTap(sender: UITapGestureRecognizer){
        
     print(sender.locationInView(searchTableView))
      
            print("tap")
        if (searchTableView.hidden == false && sender.locationInView(view).y>view.frame.height/2.0){
        searchField.resignFirstResponder()
        searchField.hidden=true
        searchTableView.hidden = true
         waypointbutton.hidden = false
        }else{
            if searchTableView.hidden{
            searchField.resignFirstResponder()
           searchField.hidden=true
            if xButton.hidden == true {
            waypointbutton.hidden = false
            }
        }
        }
    }
    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool {
        print("should diplay")
        var shouldDisplay = false
        let defaults = NSUserDefaults.standardUserDefaults()
  
        if defaults.boolForKey("viewFromLaunch"){
            defaults.setBool(false, forKey: "viewFromLaunch")
            shouldDisplay = true
            print("true")
        }
        print("\(shouldDisplay)")
        return shouldDisplay
        
    }
    
    
    func setDisplay(item: MKMapItem){

        if locationManager.location != nil {
        waypointbutton.hidden=true
  
        HoneName.hidden=false
        HoneDistance.hidden=false
        HoneName.text = item.name
        xButton.hidden=false
        //xButton.hidden = false
        let meteredDistance = distanceBetweenPoints(item.placemark.location!)
        var standardDist = metersToMiles(meteredDistance, allowConvert: false).0
        if(metersToMiles(meteredDistance, allowConvert: false).1){
            standardDist += " Miles"
        }else{
            standardDist += " ft"
        }
        HoneDistance.text = standardDist
      //  println(item.placemark.location.coordinate.latitude);
     //   println(item.placemark.location.coordinate.longitude);

       //println(locationManager.location.coordinate.latitude-item.placemark.location.coordinate.latitude);
        //println(item.placemark.location.coordinate.longitude);
        //println(locationManager.location.coordinate.longitude-item.placemark.location.coordinate.longitude);
        let degrees = getCompassBearing(locationManager.location!.coordinate, endCoor: item.placemark.location!.coordinate)
            UIView.animateWithDuration(NSTimeInterval(0.6), animations: {
           
        self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(-degrees) + CGFloat(-self.heading))
                })
        arrow.hidden=false
        honeButton.hidden=true
       // println(heading)
        print("degrees \(degrees)")
        } else if !locationAlert{
            
            let alertController = UIAlertController(title: "Sorry!", message:
                "We cannot find your current location, please make sure Location Services are turned on", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            locationAlert = true
             waypointbutton.hidden=false

        }
    }
  
    
    @IBOutlet weak var xButton: UIButton!
    @IBAction func endCurrentHeading(sender: UIButton) {
        arrow.hidden=true
        honeButton.hidden=false
        HoneName.hidden=true
        HoneDistance.hidden=true
        sender.hidden=true
        currentMapItem=nil
        waypointbutton.hidden=false

        
    }
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var searchField: UITextField!

    @IBAction func searchPressed(sender: UIButton) {
        print("hone pressed")
        locationAlert = false
        if(locationManager.location != nil){
        if searchField.hidden{
            if Connected.isConnectedToNetwork(){
                
            
            searchField.hidden=false;
            waypointbutton.hidden=true
            searchField.becomeFirstResponder()
            
          
            }else{
                let alertController = UIAlertController(title: "No Internet Connection!", message:
                    "Please make sure you are connected to a network", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
  
            }
        }else{
            print("hide")
            searchField.hidden=true;
             waypointbutton.hidden=false
            searchField.resignFirstResponder()
            searchTableView.hidden = true
         
        }
        }else{
            searchField.hidden=true;
            let alertController2 = UIAlertController(title: "Location Not Found", message:
                "Please make sure Location Services are turned on to enable search", preferredStyle: UIAlertControllerStyle.Alert)
            alertController2.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            presentViewController(alertController2, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var waypointbutton: UIButton!
    

    @IBAction func waypointPressed(sender: UIButton) {
        performSegueWithIdentifier("WayPointSegue", sender: self)
    }
    
    func handleSwipe (sender: UISwipeGestureRecognizer){
        if sender.state == .Ended{
            performSegueWithIdentifier("WayPointSegue", sender: self)
        }
    }
    
    
    func getCompassBearing(startCoor: CLLocationCoordinate2D, endCoor: CLLocationCoordinate2D) -> Double{
        let latdif = startCoor.latitude - endCoor.latitude
        let longdif = startCoor.longitude - endCoor.longitude
        print(latdif)
        print(longdif)
        var degrees = atan(latdif / longdif)
        
        if longdif > 0{
            degrees=degrees + M_PI/2.0
        }else{
            degrees=degrees - M_PI/2.0
        }
        return degrees
        
    }
    
    
    func suggest() {
        //println("suggests")
        searchField.becomeFirstResponder()
        searchResultList.removeAll(keepCapacity: false)
        mapItemsList.removeAll(keepCapacity: false)

        if(searchField.text!.isEmpty){
            searchTableView.hidden = true
        }
        if (searchField.hidden){
            searchField.resignFirstResponder()
        }
        let search=FindLocations()
      
        search.searchSuggestions(self.searchField.text!, sender: self)
        
                }
    
    func updateSearchDisplay(){
        results.removeAll(keepCapacity: false)
       
    

        for index in 0...30{
            
            if !searchResultList.isEmpty && searchResultList.count>index && !searchField.hidden && !searchField.text!.isEmpty {
                var sortedMaps = mapItemsList

                
                let name: String = sortedMaps[index].name ?? ""
                  //  sortedMaps[index].placemark.addressDictionary["FormattedAddressLines"]?.componentsJoinedByString(", ")) ??
                let num = sortedMaps[index].placemark.subThoroughfare ?? ""
                var street = sortedMaps[index].placemark.thoroughfare ?? ""
                if !street.isEmpty{
                street = street  + ", "
                }
                var town = sortedMaps[index].placemark.locality ?? ""
                if !town.isEmpty {
                town = town + ", "
                }
                let state = sortedMaps[index].placemark.administrativeArea ?? ""
                let address =  num + " " + street + town + state
               
                let address1 = address ?? ""
      
                
                let distance = metersToMiles(distanceBetweenPoints(sortedMaps[index].placemark.location!), allowConvert: true).0 + " mi"

                let mapi: (MKMapItem) = sortedMaps[index]
                let element = (name, address1, distance, mapi)
                var duplicate = false
                for (index1, result) in results.enumerate(){
                        if result.3.placemark.location!.coordinate.latitude == element.3.placemark.location!.coordinate.latitude && result.3.placemark.location!.coordinate.longitude == element.3.placemark.location!.coordinate.longitude{

                        duplicate = true
                            if result.2.isEmpty {
                            results[index1].2 = element.2
                            }
                       
                    }
                }
                if !duplicate {
                        results.insert(element, atIndex: results.count)
                    
                    
                }
                
            }else{
            
            searchTableView.layer.borderColor = UIColor.blueColor().CGColor
            searchTableView.layer.borderWidth = CGFloat(3.0)
            searchTableView.hidden=false
            searchTableView.allowsSelection = true
            tapgest?.cancelsTouchesInView = false
            searchTableView.reloadData()
            break;
            }
            
        }
        
    if searchField.text!.isEmpty {
    searchTableView.hidden = true
    }
    
}

    func distanceBetweenPoints(placeLocation: CLLocation)->String{
        var meteredDistance:String = ""
        if let distanceAway=locationManager.location?.distanceFromLocation(placeLocation){
            let submeteredDistance=Double(distanceAway)
            meteredDistance=String(format: "%.1f",submeteredDistance)
            
        }
        return meteredDistance
    }
    func sortByDistance(mp1: MKMapItem, mp2: MKMapItem)->Bool{
        let d1=(distanceBetweenPoints(mp1.placemark.location!) as NSString).doubleValue
        let d2=(distanceBetweenPoints(mp2.placemark.location!) as NSString).doubleValue
        return d1 < d2
    }
    
    func metersToMiles(meters: String, allowConvert: Bool) -> (String,Bool){
        let meterDouble=(meters as NSString).doubleValue
        let feetinM=3.2808399
        let feetinMile=5280.0
        var result: Double
        var converted: Bool
        let convertedFeet=meterDouble * feetinM
        if convertedFeet > feetinMile || allowConvert{
            result = convertedFeet / feetinMile
            converted=true
        }else{
            result=convertedFeet
            converted=false
        }
        
        return(String(format:"%.1f",result),converted)
        
    }
    
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  results.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MyTableViewCell = searchTableView.dequeueReusableCellWithIdentifier("result") as! MyTableViewCell
        
        cell.title.text = results[indexPath.row].0
        cell.subtitle.text = results[indexPath.row].1
        cell.distance.text = results[indexPath.row].2
        cell.userInteractionEnabled = true

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        setDisplay(results[indexPath.row].3)
        currentMapItem = results[indexPath.row].3
        tableView.hidden = true
        searchField.hidden = true
        searchField.resignFirstResponder()
    }
   
    func textFieldShouldClear(textField: UITextField) -> Bool {
        searchTableView.hidden = true
        searchField.resignFirstResponder()

        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (touch.view == honeButton){
            return false
        }
        else{
            return true
        }
    }
    
}

    
    
    





