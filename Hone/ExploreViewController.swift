//
//  ExploreViewController.swift
//  Hone
//
//  Created by Joey Donino on 12/12/15.
//  Copyright © 2015 Joey Donino. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var exploreTableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ExploreTableViewCell = exploreTableView.dequeueReusableCellWithIdentifier("exploreTableCell") as! ExploreTableViewCell
        
  
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        }
        
        
    func getfromServer(){
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

    @IBAction func plusPressed(sender: UIButton) {
       // postToServer()
    }
    
    @IBAction func minusPressed(sender: UIButton) {
        getfromServer()
    }
    func postToServer(){
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
    
    
    
    
    
    
    
    

}
