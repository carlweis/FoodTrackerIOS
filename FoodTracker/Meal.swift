//
//  Meal.swift
//  FoodTracker
//
//  Created by Carl Weis on 5/13/16.
//  Copyright © 2016 Carl Weis. All rights reserved.
//

import UIKit

class Meal {
    
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    var review: String
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int, review: String) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.review = review
        
        // Initialization should fail if ther eis no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
}
