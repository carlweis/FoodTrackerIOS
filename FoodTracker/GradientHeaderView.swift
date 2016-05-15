//
//  GradientHeaderView.swift
//  FoodTracker
//
//  Created by Carl Weis on 5/13/16.
//  Copyright © 2016 Carl Weis. All rights reserved.
//

import UIKit

@IBDesignable class GradientHeaderView: UIView {
    
    // MARK: Properties
    
    // Gradient layer that is added on top of the view
    var gradientLayer: CAGradientLayer!
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }
    
    // MARK: Overrides
    
    // Lays out all the subviews it has, in our case the gradient layer
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = frame
    }
    
    // MARK: Inspectable
    
    // Top color of the gradient
    @IBInspectable var topColor: UIColor = UIColor.blackColor() {
        didSet {
            updateUI()
        }
    }
    
    // Bottom color of the gradient
    @IBInspectable var bottomColor: UIColor = UIColor.clearColor() {
        didSet {
            updateUI()
        }
    }
    
    // At which vertical point the layer should end
    @IBInspectable var bottomYPoint: CGFloat = 0.6 {
        didSet {
            updateUI()
        }
    }
    
    
    // MARK: Helper Functions
    
    // Updates the UI
    func updateUI() {
        setNeedsDisplay()
    }
    
    // Setup the gradient layer
    func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [topColor.CGColor, bottomColor.CGColor]
        gradientLayer.startPoint = CGPoint(x:0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: bottomYPoint)
        layer.addSublayer(gradientLayer)
    }
    
    // Adjusts the background of the view if user scrolls down enough
    func adjustBackground(isClear: Bool) {
        if isClear == true {
            gradientLayer.hidden = false
            backgroundColor = UIColor.clearColor()
        } else {
            gradientLayer.hidden = true
            backgroundColor = UIColor(red: CGFloat(54/255.0), green: CGFloat(54/255.0), blue: CGFloat(54/255.0), alpha: 1.0)
        }
    }
    
}
