//
//  AddExplorePointViewController.swift
//  Hone
//
//  Created by Joey Donino on 12/13/15.
//  Copyright © 2015 Joey Donino. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddExplorePointViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var descriptionTextfield: UITextField!
    var imageHere: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        retakeButton.hidden = true;
        descriptionTextfield.delegate = self
        pickedImage.layer.cornerRadius = 10
        pickedImage.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var retakeButton: UIButton!
    @IBAction func reTakeButtonPressed(sender: UIButton) {
        cameraPushed(cameraButton)
        
        
        
    }
    @IBAction func cancelButtonPressed(sender: UIButton) {
        
        
        
        
        
        
    }
    @IBOutlet weak var cameraButton: UIButton!

    @IBAction func cameraPushed(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            
            
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker,animated: true,completion:nil)
          
            
            
            
        }
        
        
        
    }
    @IBOutlet weak var pickedImage: UIImageView!
    
    @IBAction func sharePressed(sender: UIButton) {
        let data = UIImageJPEGRepresentation(imageHere!, CGFloat(0.8))

        let jsonString =  data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
   
        postToServer(jsonString!)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        pickedImage.image = image
        imageHere = image
        cameraButton.hidden = true
        picker.dismissViewControllerAnimated(true, completion: nil)
        retakeButton.hidden=false
        
    }
    
    func postToServer(imageString: String){
        print("contact pressed")
        let urlPath: String = "https://honeinapp007.appspot.com"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "post"
        let params = ["description":descriptionTextfield.text!, "image":imageString] as Dictionary<String, String>
        
        do{
            try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: [])
            
        }catch let error{
            print(error)
        }
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            if data != nil {
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            do{
                _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
                
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            }catch let err{
                print(err)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            }
        })
        task.resume()
        
        
        
    }
    

    
    
    
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        
        textField.resignFirstResponder()
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
