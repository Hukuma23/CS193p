//
//  GraphView.swift
//  Calculator
//
//  Created by Nikita Litvinov on 02.02.17.
//  Copyright © 2017 Tatiana Kornilova. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var axesDrawer = AxesDrawer();
    
    @IBInspectable
    var scale : CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth : CGFloat = 2.0 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var color : UIColor = UIColor.black { didSet { setNeedsDisplay() } }

    private var originSet : CGPoint? { didSet { setNeedsDisplay() } }
    var origin : CGPoint {
        get {
            return originSet ?? CGPoint(x: bounds.midX, y: bounds.midY)
        }
        
        set {
            originSet = newValue
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
    }


}
