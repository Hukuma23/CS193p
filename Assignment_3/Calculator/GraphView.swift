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
    
    var yForX : ((_ x: Double) -> Double?)? { didSet { setNeedsDisplay() } }
    
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
    
    // MARK: - Gestures
    
    func scale(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    func originMove(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended: fallthrough
        case .changed:
            let translation = gesture.translation(in: self)
            if translation != CGPoint.zero {
                origin.x += translation.x
                origin.y += translation.y
                gesture.setTranslation(CGPoint.zero, in: self)
            }
        default: break
        }
    }
    
    func origin(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            origin = gesture.location(in: self)
        }
    }
    
    // MARK: - Drawing
    
    func drawCurveInRect(bounds: CGRect, origin: CGPoint, scale: CGFloat) {
        color.set()
        
        var xGraph, yGraph : CGFloat
        var x : Double { return Double((xGraph - origin.x) / scale) }
        
        var oldPoint = OldPoint(yGraph: 0.0, normal: false)
        var discontinuity : Bool {
            return abs(yGraph - oldPoint.yGraph) > max(bounds.width, bounds.height) * 1.5
        }
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        for i in 0 ... Int(bounds.size.width * contentScaleFactor) {
            xGraph = CGFloat(i) / contentScaleFactor
            guard let y = (yForX)?(x), y.isFinite
                else { oldPoint.normal = false; continue }
            
            yGraph = origin.y - CGFloat(y) * scale
            
            if !oldPoint.normal {
                path.move(to: CGPoint(x: xGraph, y: yGraph))
            } else {
                guard !discontinuity else {
                    oldPoint = OldPoint(yGraph: yGraph, normal: false)
                    continue
                }
                
                path.addLine(to: CGPoint(x: xGraph, y: yGraph))
            }
            
            oldPoint = OldPoint(yGraph: yGraph, normal: true)
        }
        path.stroke()
        
    }
    
    private struct OldPoint {
        var yGraph : CGFloat
        var normal : Bool
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        
        drawCurveInRect(bounds: bounds, origin: origin, scale: scale)
    }
    
    
}
