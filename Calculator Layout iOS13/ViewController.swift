/*
 
 Created by Jeremy Wang
 
 Last Updated: 3/3/2025
 
/// (Documentation comment):
Used to document code elements like classes, functions, properties, etc.
Parsed by Xcode to generate Quick Help and can be used with documentation generation tools.
Helps provide detailed explanations that show up in tooltips and external documentation.
*/

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var displayLabel: UILabel!
    
    // MARK: - Properties
    private var calculator = CalculatorModel()
    private var userIsTyping = false  // tracks if user is in the middle of typing digits
    
    /// Computed property to make code cleaner
    private var displayValue: Double {
        get {
            return Double(displayLabel.text!) ?? 0
        }
        set {
            // Remove trailing .0 if integer,
            // The floor function returns the largest integer value that is less than or equal to the given number.
            if floor(newValue) == newValue {
                displayLabel.text = String(Int(newValue))
            } else {
                displayLabel.text = String(newValue)
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = "0"
    }
    
    // MARK: - Actions
    
    /// Handles digit buttons (0–9).
    @IBAction func digitPressed(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        
        if userIsTyping {
            // Append the new digit to the existing label text
            displayLabel.text?.append(digit)
        } else {
            // Replace the label text with the new digit
            displayLabel.text = digit
            userIsTyping = true
        }
    }
    
    /// Handles the operators (+, -, ×, ÷, =).
    @IBAction func operationPressed(_ sender: UIButton) {
        guard let operationSymbol = sender.currentTitle else { return }
        
        // When the user presses an operator, we first set or calculate with the current display value
        if operationSymbol == "=" {
            // Complete the current operation
            if let result = calculator.calculateResult(with: displayValue) {
                displayValue = result
            }
        } else {
            // For +, -, ×, ÷
            if let result = calculator.setOperation(with: displayValue, operation: operationSymbol) {
                displayValue = result
            }
        }
        
        // Reset typing state after an operator is pressed
        userIsTyping = false
    }
    
    // Handles special function buttons: AC, +/-, %.
    
    @IBAction func functionPressed(_ sender: UIButton) {
        
            guard let functionSymbol = sender.currentTitle else { return }
            
            switch functionSymbol {
                case "AC":
                    calculator.clearAll()
                    displayLabel.text = "0"
                    userIsTyping = false
                case "+/-":
                    displayValue = calculator.plusMinus(displayValue)
                case "%":
                    displayValue = calculator.percent(displayValue)
                default:
                    break
            }
            
            // If the user pressed a function while typing, reset the typing state
            userIsTyping = false
        }
    }
    

