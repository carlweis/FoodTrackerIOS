//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Carl Weis on 5/13/16.
//  Copyright © 2016 Carl Weis. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var meals = [Meal]()
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red:0.949,  green:0.949,  blue:0.949, alpha:1)
        
        // Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load the sample data
            loadSampleMeals()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! MealTableViewCell
//        selectedCell.contentView.backgroundColor = UIColor(red:0.996,  green:0.135,  blue:0.303, alpha:1)
//        selectedCell.contentView.tintColor = UIColor.whiteColor()
//        selectedCell.nameLabel.textColor = UIColor.whiteColor()
//        selectedCell.reviewLabel.textColor = UIColor.whiteColor()
//    }
//    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let cellToDeSelect = tableView.cellForRowAtIndexPath(indexPath) as! MealTableViewCell
//        cellToDeSelect.contentView.backgroundColor = UIColor.clearColor()
//        cellToDeSelect.nameLabel.textColor = UIColor.darkTextColor()
//        cellToDeSelect.reviewLabel.textColor = UIColor.darkTextColor()
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        let meal = meals[indexPath.row]
        
        // Configure the cell
        cell.nameLabel.text = meal.name
        
        // truncate the meal review to only disply the first 20 characters
        cell.reviewLabel.text = meal.review
        
        
        // configure the photo
        cell.photoImageView.image = meal.photo
        cell.photoImageView.layer.cornerRadius = cell.photoImageView.frame.size.width / 2
        cell.photoImageView.clipsToBounds = true
        cell.photoImageView.layer.borderWidth = 3.0;
        cell.photoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        cell.ratingControl.rating = meal.rating
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Show an alert to ask the user to confirm the delete
            let title = "Delete \(meals[indexPath.row].name)?"
            let message = "Are you sure you want to delete this meal?"
            var confirmAlert: UIAlertController
        
            // if ipad
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                confirmAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            } else {
                confirmAlert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            confirmAlert.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                // Delete the row from the data source
                self.meals.removeAtIndex(indexPath.row)
                self.saveMeals()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            confirmAlert.addAction(deleteAction)
            // present the alert controller
            presentViewController(confirmAlert, animated: true, completion: nil)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array and add a new row to the talbe view.
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the meals.
            saveMeals()
        }
    }
    
    // MARK: Data Helpers
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4, review: "The best salad I've ever had!")!
        
        let photo2 = UIImage(named: "meal2")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5, review: "Can't beat a good old classic.")!
        
        let photo3 = UIImage(named: "meal3")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3, review: "Not my favorite, but it was good.")!
        
        meals += [meal1, meal2, meal3]
    }
    
    
    // MARK: NSCoding
    
    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }
}
