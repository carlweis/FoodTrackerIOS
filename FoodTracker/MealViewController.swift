//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Carl Weis on 5/13/16.
//  Copyright © 2016 Carl Weis. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate,
                      UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
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
        
        // Enable the Save button only if the text field has a valid Meal name and review.
        checkValidMealName()
        checkValidMealReview()
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
        dismissViewControllerAnimated(true, completion: nil)
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

