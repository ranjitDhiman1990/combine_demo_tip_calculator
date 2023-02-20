//
//  tip_calculatorUITests.swift
//  tip-calculatorUITests
//
//  Created by Dhiman Ranjit on 18/02/23.
//

import XCTest

final class tip_calculatorUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    private var screen: CalculatorScreen {
        CalculatorScreen(app: app)
    }
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testResultViewDefaultValues() {
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$0")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
    }
    
    // User enters $100 bill
    func testRegularTip() {
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$100")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        
        // User selects 10% tip
        screen.selectTip(tip: .tenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$110")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$110")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$10")
        
        // User selects 15% tip
        screen.selectTip(tip: .fifteenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$115")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$115")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$15")
        
        // User selects 20% tip
        screen.selectTip(tip: .twentyPercent)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$120")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")
        
        // User selects custom tip
        screen.selectTip(tip: .custom(value: 12))
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$112")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$112")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$12")
        
        
        // User splis the bill by 4
        screen.selectIncrementButton(numberOfTp: 3)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$28")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$112")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$12")
        
        // User splis the bill by 2
        screen.selectDecrementButton(numberOfTp: 2)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$56")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$112")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$12")
    }
    
    func testResetButton() {
        screen.enterBill(amount: 200)
        screen.selectTip(tip: .custom(value: 25))
        screen.selectIncrementButton(numberOfTp: 1)
        screen.doubleTapLogoView()
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        XCTAssertEqual(screen.billInputViewTextfield.label, "")
        XCTAssertEqual(screen.quantityValueLabel.label, "1")
        XCTAssertEqual(screen.customTipButton.label, "Custom tip")
    }
    
}
