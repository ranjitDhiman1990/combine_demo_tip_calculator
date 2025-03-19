# Tip Calculator Project

This project demonstrates the use of the **Combine framework** in Swift for reactive programming, along with examples of **Unit Test Cases** and **UI Test Cases**. The app is a simple Tip Calculator built using the MVVM (Model-View-ViewModel) architecture.

---

## **Table of Contents**
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Folder Structure](#folder-structure)
5. [Setup and Installation](#setup-and-installation)
6. [Combine Framework Usage](#combine-framework-usage)
7. [Testing](#testing)
   - Unit Tests
   - UI Tests
8. [Screenshots](#screenshots)

---

## **Project Overview**
The Tip Calculator app allows users to:
- Enter a bill amount.
- Choose a tip percentage (None, 10%, 15%, 20%, or custom).
- Split the bill among multiple people.
- Reset the calculator.

The project is designed to demonstrate:
- Reactive programming using the Combine framework.
- Writing effective Unit Test Cases and UI Test Cases.

---

## **Features**
- Reactive updates to UI components using Combine.
- MVVM architecture for clean and testable code.
- Unit tests for business logic.
- UI tests for user interaction.

---

## **Tech Stack**
- **Programming Language:** Swift
- **Frameworks:** Combine, XCTest
- **Design Pattern:** MVVM
- **Architecture:** MVVM
- **IDE:** Xcode

---

## **Folder Structure**

| Folder/File                    | Description                                               |
|--------------------------------|-----------------------------------------------------------|
| `Config/`                       | Configuration files.                                       |
| `Extensions/`                   | Swift extensions.                                         |
| `Models/`                       | Contains data models (e.g., `Result`).                    |
| `Resources/`                    | Contains app resources like images and assets.            |
| `Service/`                      | Provides auxiliary services (e.g., `AudioPlayerService`). |
| `UIFactory/`                    | Contains the UI creation Factory.                                         |
| `ViewModel/`                   | Contains the ViewModel (`CalculatorVM.swift`).            |
| `Views/`                       | Contains UI components (e.g., `CalculatorVC.swift`).     |
| `tip-calculatorTests/`         | Contains unit test cases.                                 |
| `tip-calculatorUITests/`      | Contains UI test cases.                                |

---

## **Setup and Installation**

1. Clone the repository:
git clone https://github.com/ranjitDhiman1990/combine_demo_tip_calculator

2. Open the project in Xcode:

3. Build and run the app on a simulator or device.

---

## **Combine Framework Usage**

The project leverages Combine for reactive programming:
1. Publishers are used to observe changes in bill amount, tip percentage, and split count.
2. The `transform` function in `CalculatorVM.swift` combines these inputs using `CombineLatest3` to calculate:
- Total tip amount.
- Total bill amount.
- Amount per person.

Example snippet from `CalculatorVM.swift`:
let updateViewPublisher = Publishers.CombineLatest3(
    input.billPublisher,
    input.tipPublisher,
    input.splitPublisher
).flatMap { [unowned self] (bill, tip, split) in
    let totalTip = getTipAmount(bill: bill, tip: tip)
    let totalBill = bill + totalTip
    let amountPerPerson = totalBill / Double(split)
    let result = Result(amountPerPerson: amountPerPerson, totalBill: totalBill, tipBill: totalTip)
    return Just(result)
}.eraseToAnyPublisher()


---

## **Testing**

### **Unit Tests**
Unit tests are written to validate the business logic in the ViewModel (`CalculatorVM.swift`). For example:
- Verifying correct calculation of tips and splits.
- Ensuring edge cases (e.g., zero bill or split count) are handled correctly.

**Example Unit Test**

This test checks the `getTipAmount` function for various tip percentages, ensuring that the correct tip amount is calculated for a given bill amount.

import XCTest
@testable import tip_calculator

final class CalculatorVMTests: XCTestCase {
    var vm: CalculatorVM!

    override func setUp() {
        vm = CalculatorVM()
    }
    
    override func tearDown() {
        vm = nil
    }
    
    func testGetTipAmount() {
        // Arrange
        let billAmount: Double = 100.0
        
        // Act & Assert
        XCTAssertEqual(vm.getTipAmount(bill: billAmount, tip: .none), 0.0, "No tip calculation failed")
        XCTAssertEqual(vm.getTipAmount(bill: billAmount, tip: .tenPercent), 10.0, "10% tip calculation failed")
        XCTAssertEqual(vm.getTipAmount(bill: billAmount, tip: .fifteenPercent), 15.0, "15% tip calculation failed")
        XCTAssertEqual(vm.getTipAmount(bill: billAmount, tip: .twentyPercent), 20.0, "20% tip calculation failed")
        XCTAssertEqual(vm.getTipAmount(bill: billAmount, tip: .custom(value: 25)), 25.0, "Custom tip calculation failed")
    }
}



### **UI Tests**
UI tests validate user interactions such as:
- Entering a bill amount.
- Selecting a tip percentage.
- Splitting the bill among multiple people.
- Resetting the calculator.

**Example UI Test**

This UI test simulates entering a bill amount, tapping the reset button, and verifying that the bill amount text field is cleared as a result.

import XCTest

final class TipCalculatorUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }
    
    func testResetButtonFunctionality() {
        // Arrange
        let billTextField = app.textFields["billTextField"]
        let resetButton = app.buttons["resetButton"]
    
        // Act
        billTextField.tap()
        billTextField.typeText("100")
        resetButton.tap()
    
        // Assert
        XCTAssertEqual(billTextField.value as? String, "", "Bill input not cleared after reset")
    }
}
