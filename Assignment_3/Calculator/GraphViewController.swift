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
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.scale(_:))))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.originMove(_:))))
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.origin(_:)))
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapRecognizer)
            updateUI()
        }
    }
    
    func updateUI() {
        graphView?.yForX = yForX
    }
    
    
}
