//
//  GraphViewController.swift
//  Calculator
//
//  Created by Nikita Litvinov on 02.02.17.
//  Copyright © 2017 Tatiana Kornilova. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var destinationVC = segue.destination
        if let navCon = destinationVC as? UINavigationController {
            destinationVC = navCon.visibleViewController ?? destinationVC
        }
        if let graphVC = destinationVC as? GraphViewController {
            if let identifier = segue.identifier {
                
            }
        }
    }


}