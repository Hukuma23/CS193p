//
//  GraphViewController.swift
//  Calculator
//
//  Created by Nikita Litvinov on 02.02.17.
//  Copyright © 2017 Tatiana Kornilova. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var yForX : ((_ x : Double) -> Double?)? { didSet { updateUI() } }
    
    let defaults = UserDefaults.standard
    private struct Keys {
        static let Scale    = "GraphViewController.Scale"
        static let Origin   = "GraphViewController.Origin"
    }
    
    var scale : CGFloat {
        get { return defaults.object(forKey: Keys.Scale) as? CGFloat ?? 50.0 }
        set { defaults.set(Keys.Origin, forKey: Keys.Scale) }
    }
    
    var originRelativeToCenter : CGPoint {
        get {
            let originArray = defaults.object(forKey: Keys.Origin) ?? [CGFloat]()
            let factor = CGPoint(x: (originArray as! [CGFloat]).first ?? CGFloat(0.0), y: (originArray as! [CGFloat]).last ?? CGFloat(0.0))
            
            return CGPoint(x: factor.x * graphView.bounds.size.width, y: factor.y * graphView.bounds.size.height)
        }
        
        set {
            let factor = CGPoint(x: newValue.x / graphView.bounds.size.width, y: newValue.y / graphView.bounds.size.height)
            defaults.set([factor.x, factor.y], forKey: Keys.Origin)
        }
    }
    
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.scale(_:))))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.originMove(_:))))
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.origin(_:)))
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapRecognizer)
            
            graphView.scale = scale
            graphView.originRelativeToCenter = originRelativeToCenter
            updateUI()
        }
    }
    
    var widthOld = CGFloat(0.0)
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        widthOld = graphView.bounds.size.width
        originRelativeToCenter = graphView.originRelativeToCenter
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !(graphView.bounds.size.width == widthOld) {
            graphView.originRelativeToCenter = originRelativeToCenter
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scale = graphView.scale
        originRelativeToCenter = graphView.originRelativeToCenter
    }
    
    func updateUI() {
        graphView?.yForX = yForX
    }
    
    
}
