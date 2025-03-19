# Combine Demo Tip Calculator
Tip Calculator Project
This project demonstrates the use of the Combine framework in Swift for reactive programming, along with examples of Unit Test Cases and UI Test Cases. The app is a simple Tip Calculator built using the MVVM (Model-View-ViewModel) architecture.

Table of Contents
Project Overview

Features

Tech Stack

Folder Structure

Setup and Installation

Combine Framework Usage

Testing

Unit Tests

UI Tests

Screenshots

Project Overview
The Tip Calculator app allows users to:

Enter a bill amount.

Choose a tip percentage (10%, 15%, 20%, or custom).

Split the bill among multiple people.

Reset the calculator.

The project is designed to demonstrate:

Reactive programming using the Combine framework.

Writing effective Unit Test Cases and UI Test Cases.

Features
Reactive updates to UI components using Combine.

MVVM architecture for clean and testable code.

Unit tests for business logic.

UI tests for user interaction.

Tech Stack
Programming Language: Swift

Frameworks: Combine, XCTest

Design Pattern: MVVM

IDE: Xcode

Folder Structure
Folder/File	Description
Models/	Contains data models (e.g., Result).
ViewModel/	Contains the ViewModel (CalculatorVM.swift).
Views/	Contains UI components (e.g., CalculatorVC.swift).
Service/	Provides auxiliary services (e.g., AudioPlayerService).
tip-calculatorTests/	Contains unit test cases.
tip-calculatorUITests/	Contains UI test cases.
Setup and Installation
Clone the repository:

bash
git clone <repository-url>
Open the project in Xcode:

bash
cd tip-calculator
open TipCalculator.xcodeproj
Build and run the app on a simulator or device.

Combine Framework Usage
The project leverages Combine for reactive programming:

Publishers are used to observe changes in bill amount, tip percentage, and split count.

The transform function in CalculatorVM.swift combines these inputs using CombineLatest3 to calculate:

Total tip amount.

Total bill amount.

Amount per person.

Example snippet from CalculatorVM.swift:

swift
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
Testing
Unit Tests
Unit tests are written to validate the business logic in the ViewModel (CalculatorVM.swift). For example:

Verifying correct calculation of tips and splits.

Ensuring edge cases (e.g., zero bill or split count) are handled correctly.

Example test case:

swift
func testCalculateTip() {
    let viewModel = CalculatorVM()
    // Simulate input publishers for bill, tip, and split count.
    // Assert expected results for total tip and amount per person.
}
UI Tests
UI tests validate user interactions such as:

Entering a bill amount.

Selecting a tip percentage.

Splitting the bill among multiple people.

Resetting the calculator.

Example UI test case:

swift
func testResetButton() {
    let app = XCUIApplication()
    app.launch()
    // Interact with UI elements and assert reset functionality works as expected.
}
Screenshots
Include screenshots or GIFs of the app's UI to showcase its functionality (e.g., calculator screen before and after entering inputs).

This project serves as an excellent starting point for learning how to use Combine effectively in iOS development while maintaining clean code with proper testing practices.
