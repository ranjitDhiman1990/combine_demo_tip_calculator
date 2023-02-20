//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by Dhiman Ranjit on 19/02/23.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {

    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var buttonDecrement: UIButton = {
        let button = buildButton(title: "-", corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        button.accessibilityIdentifier = ScreenIdentifier.SplitInputView.decrementButton.rawValue
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(self.spliSubject.value == 1 ? 1 : self.spliSubject.value - 1)
        }.assign(to: \.value, on: spliSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var buttonIncrement: UIButton = {
        let button = buildButton(title: "+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.accessibilityIdentifier = ScreenIdentifier.SplitInputView.incrementButton.rawValue
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(self.spliSubject.value + 1)
        }.assign(to: \.value, on: spliSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private let quantityLabel: UILabel = {
        let label = LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20), backgroundColor: .white)
        label.accessibilityIdentifier = ScreenIdentifier.SplitInputView.quantityValueLabel.rawValue
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonDecrement,
            quantityLabel,
            buttonIncrement
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private let spliSubject = CurrentValueSubject<Int, Never>(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        return spliSubject.removeDuplicates().eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        spliSubject.send(1)
    }
    
    private func layout() {
        [headerView, stackView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [buttonIncrement, buttonDecrement].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }
    
    private func observe() {
        spliSubject.sink { [unowned self] quantity in
            quantityLabel.text = quantity.strigValue
        }.store(in: &cancellables)
    }
    
    private func buildButton(title: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.addRoundedCorners(corners: corners, radius: 8.0)
        return button
    }
}
