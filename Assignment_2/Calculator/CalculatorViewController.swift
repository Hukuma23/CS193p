//
//  ViewController.swift
//  Calculator

//  iOS 9 CS193P Stanford Course (Task 1)
//
//  Created by Nikita Litvinov on 12/15/16.
//  Copyright © 2016 Nikita Litvinov. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var displayLog: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.PropertyList?

    
    private var displayValue : Double? {
        get{
            if let text = display.text,
                let value = formatter.number(from: text)?.doubleValue {
                return value
            }
            return nil
        }
        set{
            if let value = newValue {
                display.text = formatter.string(from: NSNumber(value: value))
                displayLog.text = brain.description + (brain.isPartialResult ? " …" : " =")
            } else {
                display.text = "0"
                displayLog.text = " "
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    
    private var resultValue : (value: Double, error: String?) = (0, nil) {
        didSet {
            switch resultValue {
            case (_, nil): displayValue = resultValue.value
            case (_ , let error):
                display.text = error
                displayLog.text = brain.description + (brain.isPartialResult ? "..." : "=")
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
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
    
    
    
    @IBAction func pushVariable(_ sender: UIButton) {
        let variable = sender.currentTitle!
        brain.setOperand(variableName: variable)
        resultValue = brain.result
    }
    
    
    @IBAction func setVariable(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        let variable = String(sender.currentTitle!.characters.dropFirst())
        
        brain.variableValues[variable] = displayValue
        resultValue = brain.result
        /*
         if let value = displayValue {
         brain.variableValues[variable] = value
         displayValue = brain.result
         }*/
    }
    
    
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            resultValue = brain.result
        }
    }
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    
    @IBAction func backspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            let last = display.text!.characters.index(before: display.text!.endIndex)
            
            display.text?.remove(at: last)
            if display.text!.isEmpty {
                userIsInTheMiddleOfTyping = false
                resultValue = brain.result
            }
        } else {
            brain.undoLast()
            resultValue = brain.result
        }
        
    }
    
    
    @IBAction func clearAll(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        displayLog.text = " "
        brain.clear()
        brain.clearVariables()
        resultValue = brain.result
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            if let value = displayValue {
                brain.setOperand(value)
            }
            userIsInTheMiddleOfTyping = false
        }
        if let mathimaticalSymbol = sender.currentTitle{
            if mathimaticalSymbol == "C" {
                userIsInTheMiddleOfTyping = false
                displayLog.text = " "
                brain.variableValues.removeAll()
            }
            brain.performOperation(mathimaticalSymbol)
        }
        resultValue = brain.result
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

