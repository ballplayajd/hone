//
//  MapViewController.swift
//  Hone
//
//  Created by Joey Donino on 6/18/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    var pin = MKPointAnnotation()
    var locationManager: CLLocationManager!

    var previousCreated: Bool?

    var currentWayPoint: WayPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        
        locationManager = CLLocationManager()
       
        locationManager.requestWhenInUseAuthorization()
       
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
                        if currentWayPoint != nil {

      
            print("1")
            pin.coordinate.longitude = CLLocationDegrees(currentWayPoint!.longitude)
            print("1")
            pin.coordinate.latitude = CLLocationDegrees(currentWayPoint!.latitude)
            print("1")
            if currentWayPoint!.title != ""{
            pin.title = currentWayPoint!.title
            }else{
              pin.title = "Drag me"
            }
            print("1")
            
        }else{
                    
        if locationManager.location != nil {
        pin.coordinate = locationManager.location!.coordinate
            }else{
           pin.coordinate.latitude = mapView.centerCoordinate.latitude
            pin.coordinate.longitude = mapView.centerCoordinate.longitude*3.0
            }
        pin.title = "Drag me"
        
        }
        mapView.delegate = self
        mapView.addAnnotation(pin)
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleTap(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        mapView.addGestureRecognizer(tap)

        
    }


    
    
    func handleTap(sender: UITapGestureRecognizer){
    
    }
    
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: pin, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .Purple
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = false
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView,
        didSelectAnnotationView view: MKAnnotationView){
        
       view.dragState = MKAnnotationViewDragState.Dragging
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.Starting
        {
            view.dragState = MKAnnotationViewDragState.Dragging
        }
        
       
    }
    @IBAction func DonePressed(sender: UIBarButtonItem) {
        
        if (currentWayPoint != nil){
            currentWayPoint!.latitude = pin.coordinate.latitude
            currentWayPoint!.longitude = pin.coordinate.longitude
            currentWayPoint!.title = ""
            
        }else{
            
            let wayPointObject: WayPoint = NSEntityDescription.insertNewObjectForEntityForName("WayPoint", inManagedObjectContext:  self.managedObjectContext!) as! WayPoint
            
            wayPointObject.latitude = pin.coordinate.latitude
            wayPointObject.longitude = pin.coordinate.longitude
            
            wayPointObject.created = NSDate()
            wayPointObject.fromMap = 1
            currentWayPoint = wayPointObject
        }
        
        
        
        do {
            try self.managedObjectContext?.save()
        } catch _ as NSError {
            
        }
        alertTitle(currentWayPoint!)
       
        

        
        
    }

    func alertTitle(currentWay: WayPoint){
        
        var titleTextfield: UITextField?
        
       
            let alert = UIAlertController(title: "Title ", message: nil, preferredStyle:.Alert)

            let doneAction = UIAlertAction(title: "Done", style: .Default){ action -> Void in
                self.currentWayPoint!.title = titleTextfield!.text ?? ""
                do {
                    try self.managedObjectContext?.save()
                    
                }catch {
                    
                }
                self.performSegueWithIdentifier("backToWay", sender: self)
                
                
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
    



}
