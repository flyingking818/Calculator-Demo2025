/*
 Created by Jeremy Wang
 Last updated: 3/3/2025
 
 */



import Foundation

struct CalculatorModel {
    
    // MARK: - Stored Properties
    private var previousNumber: Double?
    private var currentOperation: String?
    private var result: Double?
    
    // MARK: - Public Accessors (for Controller)
    var operation: String? {
        return currentOperation
    }
    
    /// Called when an operator (+, -, ×, ÷) is pressed.
    /// - Parameters:
    ///   - newNumber: The current number on the display.
    ///   - operation: The operator symbol ("+", "-", "×", "÷").
    /// - Returns: The updated result after applying any existing operation, or nil if this is the first operation.
    mutating func setOperation(with newNumber: Double, operation: String) -> Double? {
        
        // If we already have a previous number and operation, execute it first
        if let prev = previousNumber, let currentOp = currentOperation {
            result = performCalculation(lhs: prev, rhs: newNumber, operation: currentOp)
            previousNumber = result // carry forward for further chaining
        } else {
            // First time setting operation
            result = newNumber
            previousNumber = newNumber
        }
        
        // Update current operation
        currentOperation = operation
        
        // Return the most up-to-date result
        return result
    }
    
    /// Called when "=" is pressed, completing the current operation.
    /// - Parameter newNumber: The current number on the display.
    /// - Returns: The final result of the calculation, or nil if there was no operation set.
    mutating func calculateResult(with newNumber: Double) -> Double? {
        guard let prev = previousNumber,
              let currentOp = currentOperation else {
            // No pending operation; nothing to calculate
            return nil
        }
        
        // Perform the calculation
        result = performCalculation(lhs: prev, rhs: newNumber, operation: currentOp)
        
        // After pressing "=", we often reset the operation so that
        // the next press of a digit starts fresh or can chain properly.
        currentOperation = nil
        previousNumber = result
        
        return result
    }
    
    /// Clears all stored values (for "AC").
    mutating func clearAll() {
        previousNumber = nil
        currentOperation = nil
        result = nil
    }
    
    /// Performs the sign change ("+/-").
    /// - Parameter number: The current displayed number.
    /// - Returns: Negated value.
    func plusMinus(_ number: Double) -> Double {
        return -number
    }
    
    /// Performs percentage operation ("%").
    /// - Parameter number: The current displayed number.
    /// - Returns: number / 100.
    func percent(_ number: Double) -> Double {
        return number / 100
    }
    
    // MARK: - Private Helpers
    //lhs stands for left-hand side. It's a common naming convention used to indicate the first operand in a binary operation.
    private func performCalculation(lhs: Double, rhs: Double, operation: String) -> Double {
        switch operation {
            case "+":
                return lhs + rhs
            case "-":
                return lhs - rhs
            case "×":
                return lhs * rhs
            case "÷":
                // Avoid dividing by zero
                return rhs == 0 ? 0 : lhs / rhs
            default:
                return rhs
        }
    }
}
