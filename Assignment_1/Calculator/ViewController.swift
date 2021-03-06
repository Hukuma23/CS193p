//
//  ViewController.swift
//  Calculator

//  iOS 9 CS193P Stanford Course (Task 1)
//
//  Created by Nikita Litvinov on 12/15/16.
//  Copyright © 2016 Nikita Litvinov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var displayLog: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." {
            if display.text?.range(of: ".") == nil {
                userIsInTheMiddleOfTyping = true
            } else {
                return
            }
        }
        
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue : Double{
        get{
            return Double(display.text!)!
        }
        set{
            if newValue == 0 {
                display.text = "0"
            } else {
                display.text = formatter.string(from: NSNumber(value: newValue))
                displayLog.text = brain.description + (brain.isPartialResult ? " …" : " =")

            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathimaticalSymbol = sender.currentTitle{
            if mathimaticalSymbol == "C" {
                userIsInTheMiddleOfTyping = false
                displayLog.text = " "
            }
            brain.performOperation(mathimaticalSymbol)
        }
        displayValue = brain.result
        print("\(brain.description)")
    }
    
    let formatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.notANumberSymbol = "Error"
        formatter.groupingSeparator = " "
        formatter.locale = Locale.current
        return formatter
        
    } ()
    
}

