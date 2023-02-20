//
//  tip_calculatorTests.swift
//  tip-calculatorTests
//
//  Created by Dhiman Ranjit on 18/02/23.
//

import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {
    
    // sut -> System Under Test
    private var sut: CalculatorVM!
    private var cancellables: Set<AnyCancellable>!
    private var logoViewTapSuject: PassthroughSubject<Void, Never>!
    private var mockAudioPlayerService: MockAudioPlayerService!
    
    override func setUp() {
        mockAudioPlayerService = .init()
        sut = .init(audioPlayerService: mockAudioPlayerService)
        logoViewTapSuject = .init()
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
        logoViewTapSuject = nil
        mockAudioPlayerService = nil
    }
    
    func testResultWITOUTTipForOnePerson() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        
        // when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPesson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.tipBill, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        
        // when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPesson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.tipBill, 0)
        }.store(in: &cancellables)
    }
    
    func testResult10PercentTipFor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        
        // when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPesson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.tipBill, 10)
        }.store(in: &cancellables)
    }
    
    func testResult15PercentTipFor2Person() {
        // given
        let bill: Double = 200.0
        let tip: Tip = .fifteenPercent
        let split: Int = 2
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        
        // when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPesson, 115)
            XCTAssertEqual(result.totalBill, 230)
            XCTAssertEqual(result.tipBill, 30)
        }.store(in: &cancellables)
    }
    
    func testResult20PercentTipFor4Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .twentyPercent
        let split: Int = 4
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        
        // when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPesson, 30)
            XCTAssertEqual(result.totalBill, 120)
            XCTAssertEqual(result.tipBill, 20)
        }.store(in: &cancellables)
    }
    
    func testResultCustomTipFor3Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .custom(value: 12)
        let split: Int = 3
        
        let input = buildInput(bill: bill, tip: tip, split: split)
        
        // when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPesson, 37.333333333333336)
            XCTAssertEqual(result.totalBill, 112)
            XCTAssertEqual(result.tipBill, 12)
        }.store(in: &cancellables)
    }
    
    func testSoundPlayedAndCalculatorResetOnLogoViewTap() {
        // given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "reset calculator called")
        let expectation2 = mockAudioPlayerService.expectation
        // then
        output.resetCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancellables)
        // when
        logoViewTapSuject.send()
        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
    
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorVM.Input {
        return .init (
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPulisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSuject.eraseToAnyPublisher())
    }
}

class MockAudioPlayerService: AudioPlayerService {
    var expectation = XCTestExpectation(description: "playSound is called")
    
    func playSound() {
        expectation.fulfill()
    }
}
