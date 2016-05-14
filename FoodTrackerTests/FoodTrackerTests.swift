//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Carl Weis on 5/13/16.
//  Copyright © 2016 Carl Weis. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    // MARK: FoodTracker Tests
    
    // Tests to confirm that the Meal initializer returns when no name or negative rating is provided.
    func testMealInitialization() {
        
        // Success case.
        let potentialItem = Meal(name: "Newest meal", photo: nil, rating: 5, review: "This was the best meal ever!!!")
        XCTAssertNotNil(potentialItem)
        
        // Failure case.
        let noName = Meal(name: "", photo: nil, rating: 0, review: "")
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Meal(name: "Really bad rating", photo: nil, rating: -1, review: "")
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive")
    }
    
}
