//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Carl Weis on 5/13/16.
//  Copyright © 2016 Carl Weis. All rights reserved.
//

import UIKit
import Social

class MealViewController: UIViewController, UITextFieldDelegate,
                      UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepareForSeque(_:sender:)`
     or constructed as part of adding a new meal.
    */
    var meal: Meal?
    
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        reviewTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            shareButton.enabled = true
            shareButton.tintColor = UIColor(red:1,  green:0.267,  blue:0.216, alpha:1)
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            reviewTextField.text = meal.review
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        } else {
            shareButton.enabled = false
            shareButton.tintColor = UIColor.clearColor()
        }
        
        // Enable the Save button only if the text field has a valid Meal name and review.
        checkValidMealName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing
        saveButton.enabled = false
    }
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        checkValidMealReview()
        navigationItem.title = nameTextField.text
    }
    
    func checkValidMealName() {
        // Disable the Save button if the name text field is empty
        let name = nameTextField.text ?? ""
        saveButton.enabled = !name.isEmpty
    }
    
    func checkValidMealReview() {
        // Disable the Save button if the review text field is empty
        let review = reviewTextField.text ?? ""
        saveButton.enabled = !review.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the pciker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set the photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // Dismiss the image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            let review = reviewTextField.text ?? ""
            
            // Set the meal to be passed to the MealTableViewController after the unwind seque.
            meal = Meal(name: name, photo: photo, rating: rating, review: review)
        }
    }
    
    // MARK: Actions
    
    @IBAction func shareOnFacebook(sender: AnyObject) {
        if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
            let facebookMessageComposer: SLComposeViewController =
            SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookMessageComposer.setInitialText("\(nameTextField.text)\n\(reviewTextField.text)\nRating \(ratingControl.rating)/5")
            facebookMessageComposer.addURL(NSURL(string: "http://carlweis.com"))
            facebookMessageComposer.addImage(photoImageView.image)
            self.presentViewController(facebookMessageComposer, animated: true, completion: nil)
        } else {
            let facebookNotConfiguredAlert = UIAlertController(title: "Facebook Not Configured", message: "Please setup a facebook account", preferredStyle: .Alert)
            facebookNotConfiguredAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(facebookNotConfiguredAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        
        // Create a UIImagePickerController to let the user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Notify the ViewController when a user picks an image.
        imagePickerController.delegate = self
        
        // Present the image picker to the user.
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
}

