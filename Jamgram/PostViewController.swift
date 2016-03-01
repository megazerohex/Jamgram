//
//  PostViewController.swift
//  Jamgram
//
//  Created by Jamel Peralta Coss on 2/29/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postPhotoView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    var postPhoto = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postPhotoView.image = postPhoto
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onPost(sender: AnyObject) {
        let image = resizeImg(postPhotoView.image!, newSize: CGSizeMake(200,200))
        UserMedia.postUserImage(image, withCaption: captionField.text, withCompletion: nil)
        print("Pic is posted")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImg(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
