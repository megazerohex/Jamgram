//
//  HomeViewController.swift
//  Jamgram
//
//  Created by Jamel Peralta Coss on 2/29/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //Instance Variables
    var Umedia: [UserMedia]?
    var data = [PFObject]?()
    var countData = 5
    
    let imagePicker = UIImagePickerController()
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getPics() { (images, error) -> () in
            self.data = images
            self.tableView.reloadData()
        }
        
        //self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        countData++
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func newPost(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        //If I want from the camara
        //imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOutInBackground()
        performSegueWithIdentifier("LoginPage", sender: nil)
        print("user logged out")
    }
 
    
    //My Functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.image = originalImage
        
        dismissViewControllerAnimated(false, completion: nil)
        performSegueWithIdentifier("postViewController", sender: self)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getPics(completion: (media: [PFObject]?, error: NSError?)-> Void) {
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                completion(media: media, error: nil)
            } else {
                print("couldn't retrieve media")
            }
        }
    }
    
    //Table View properties
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(data!.indices)
        //let last = Range<Int>(data!.indices)
        //print(last.last)
        return countData
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let image = self.data?[indexPath.row]
        
        if image != nil {
            cell.captionLabel.text = image!["caption"] as? String
            
            image!["media"].getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: imageData!)
                    cell.photoView.image = image
                }
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postViewController" {
            let vc = segue.destinationViewController as! PostViewController
            vc.postPhoto = self.image
        }
    }

}









