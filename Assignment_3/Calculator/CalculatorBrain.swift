//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nikita Litvinov on 12/15/2016.
//  Copyright © 2016 Nikita Litvinov. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var internalProgram = [AnyObject]()
    private var accumulator = 0.0
    private var descriptionAccumulator = ""
    private var error : String?
    
    var isPartialResult : Bool { return pending != nil }
    private var pending: PendingBinaryOperationInfo?
    var variableValues = [String:Double]() {
        didSet {
            program = internalProgram as CalculatorBrain.PropertyList
        }
    }
    
    func setOperand (variableName: String) {
        accumulator = variableValues[variableName] ?? 0
        descriptionAccumulator = variableName
        internalProgram.append(variableName as AnyObject)
    }
    
    
    var result: (Double, String?) { return (accumulator, error) }
    var strAccumulator : String { return String(accumulator) }
    
    var description : String {
        if let pend = pending {
            return pend.descriptionOperation(pend.descriptionOperand, pend.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
        } else {
            return descriptionAccumulator
        }
    }
    
    func clear() {
        accumulator = 0
        descriptionAccumulator = ""
        pending = nil
        error = nil
        internalProgram.removeAll(keepingCapacity: false)
    }
    
    func clearVariables() {
        variableValues.removeAll(keepingCapacity: false)
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        descriptionAccumulator = formatter.string(from: NSNumber(value: accumulator)) ?? ""
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations : [String: Operation] = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }, {"±(" + $0 + ")"}, nil),
        "√": Operation.UnaryOperation(sqrt, {"√(" + $0 + ")"}, {$0 < 0 ? "√ отриц. числа" : nil}),
        "cos": Operation.UnaryOperation(cos, {"cos(" + $0 + ")"}, nil),
        "sin": Operation.UnaryOperation(sin, {"sin(" + $0 + ")"}, nil),
        "log": Operation.UnaryOperation(log10, {"log(" + $0 + ")"}, {$0 < 0 ? "log отриц. числа" : nil}),
        "x⁻¹": Operation.UnaryOperation({1 / $0}, {"(" + $0 + ")⁻¹"}, nil),
        "x²": Operation.UnaryOperation({$0 * $0}, {"(" + $0 + ")²"}, nil),
        "×": Operation.BinaryOperation({$0 * $1}, {$0 + " × " + $1}, nil),
        "÷": Operation.BinaryOperation({$0 / $1}, {$0 + " ÷ " + $1}, {$1 == 0 ? "÷ на 0" : nil}),
        "+": Operation.BinaryOperation({$0 + $1}, {$0 + " + " + $1}, nil),
        "−": Operation.BinaryOperation({$0 - $1}, {$0 + " − " + $1}, nil),
        "=": Operation.Equals,
        "C": Operation.Clear
    ]
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String, ((Double) -> String?)?)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String, ((Double, Double) -> String?)?)
        case Equals
        case Clear
    }
    
    func performOperation(_ symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                descriptionAccumulator = symbol
                accumulator = value
            case .UnaryOperation(let function, let descriptionFunction, let errorFunction):
                if pending != nil {
                    descriptionAccumulator = String(accumulator)
                }
                error = errorFunction?(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
                
                accumulator = function(accumulator)
                
            case .BinaryOperation(let function, let descriptionFunction, let errorFunction):
                executeBinaryOperation()
                if descriptionAccumulator == "" {
                    descriptionAccumulator = String(accumulator)
                }
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator, descriptionOperand: descriptionAccumulator, descriptionOperation: descriptionFunction, errorValidator: errorFunction)
                
            case .Equals:
                executeBinaryOperation()
            case .Clear:
                clear()
                
            }
        }
    }
    
    private func executeBinaryOperation() {
        if pending != nil {
            error = pending!.errorValidator?(pending!.firstOperand, accumulator)
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionOperation(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
    
    func undoLast() {
        guard !internalProgram.isEmpty else { clear(); return }
        internalProgram.removeLast()
        program = internalProgram as CalculatorBrain.PropertyList
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionOperand : String
        var descriptionOperation : (String, String) -> String
        var errorValidator :  ((Double, Double) -> String?)?
    }
    
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        if operations[operation] != nil {
                            performOperation(operation)
                        } else {
                            // operation is a variable
                            setOperand(variableName: operation)
                        }
                    }
                }
            }
        }
    }
    
    private let formatter : NumberFormatter  = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.notANumberSymbol = "Error"
        formatter.groupingSeparator = " "
        formatter.locale = Locale.current
        
        return formatter
    }()
    
}
