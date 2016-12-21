//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nikita Litvinov on 12/15/2016.
//  Copyright © 2016 Nikita Litvinov. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulator = 0.0
    private var descriptionAccumulator = ""
    var isPartialResult : Bool { return pending != nil }
    private var pending: PendingBinaryOperationInfo?
    
    
    var result: Double { return accumulator }
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
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        descriptionAccumulator = formatter.string(from: NSNumber(value: accumulator)) ?? ""
    }
    
    private var operations : [String: Operation] = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }, {"±(" + $0 + ")"}),
        "√": Operation.UnaryOperation(sqrt, {"√(" + $0 + ")"}),
        "cos": Operation.UnaryOperation(cos, {"cos(" + $0 + ")"}),
        "sin": Operation.UnaryOperation(sin, {"sin(" + $0 + ")"}),
        "log": Operation.UnaryOperation(log10, {"log(" + $0 + ")"}),
        "x⁻¹": Operation.UnaryOperation({1 / $0}, {"(" + $0 + ")⁻¹"}),
        "x²": Operation.UnaryOperation({$0 * $0}, {"(" + $0 + ")²"}),
        "×": Operation.BinaryOperation({$0 * $1}, {$0 + " × " + $1}),
        "÷": Operation.BinaryOperation({$0 / $1}, {$0 + " ÷ " + $1}),
        "+": Operation.BinaryOperation({$0 + $1}, {$0 + " + " + $1}),
        "−": Operation.BinaryOperation({$0 - $1}, {$0 + " − " + $1}),
        "=": Operation.Equals,
        "C": Operation.Clear
    ]
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String)
        case Equals
        case Clear
    }
    
    func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                descriptionAccumulator = symbol
                accumulator = value
            case .UnaryOperation(let function, let descriptionFunction):
                if pending != nil {
                    descriptionAccumulator = String(accumulator)
                }
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
                accumulator = function(accumulator)
            case .BinaryOperation(let function, let descriptionFunction):
                executeBinaryOperation()
                if descriptionAccumulator == "" {
                    descriptionAccumulator = String(accumulator)
                }
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator, descriptionOperand: descriptionAccumulator, descriptionOperation: descriptionFunction)
                
            case .Equals:
                executeBinaryOperation()
            case .Clear:
                clear()
                
            }
        }
    }
    
    private func executeBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionOperation(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionOperand : String
        var descriptionOperation : (String, String) -> String
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
