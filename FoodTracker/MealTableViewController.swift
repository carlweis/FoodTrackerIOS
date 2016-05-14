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
        
        // Load the sample data
        loadSampleMeals()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
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
    
    // MARK: Navigation
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            // Add a new meal.
            let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
            meals.append(meal)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
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
}
