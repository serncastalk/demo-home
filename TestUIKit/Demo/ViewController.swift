//
//  ViewController.swift
//  TestUIKit
//
//  Created by Duck Sern on 31/3/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let scrollableView = ScrollableSingleSectionExpandView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollableView)
        scrollableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        scrollableView.dataSource = self
        scrollableView.delegate = self
        scrollableView.bind(config: .init(
            numberItemsInScreen: 2,
            percentSmallItems: 0.3
        ))
        let stackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 16
            v.alignment = .fill
            return v
        }()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        let filledButton = FilledButton()
        filledButton.setTitle("Hello", for: .normal)
        stackView.addArrangedSubview(filledButton)
        filledButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        filledButton.addTarget(self, action: #selector(self.onTapFill), for: .touchUpInside)
        
        let disableFilledButton = FilledButton()
        disableFilledButton.setTitle("Disable Hello", for: .normal)
        disableFilledButton.isEnabled = false
        stackView.addArrangedSubview(disableFilledButton)
        disableFilledButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let outlineButton = OutlineButton()
        outlineButton.setTitle("Close", for: .normal)
        stackView.addArrangedSubview(outlineButton)
        outlineButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let textField = TextField()
        stackView.addArrangedSubview(textField)
    }
    
    @objc private func onTapFill() {
        view.endEditing(true)
    }
}

extension ViewController: ScrollableSingleSectionExpandViewDataSource {
    func numberOfItems() -> Int {
        Cell.colors.count
    }
    
    func newItemView() -> ScrollableSingleSectionItemView {
        Cell()
    }
    
    func configItemView(_ item: ScrollableSingleSectionItemView, index: Int) {
        guard let item = item as? Cell else { return }
        item.backgroundColor = Cell.colors[index]
        item.label.text = "INDEX: \(index)"
    }
}

extension ViewController: ScrollableSingleSectionExpandViewDelegate {
    func didTapOnExpandItem(index: Int) {
        print("TAP :: EXPAND INDEX :: ", index)
    }
    
    func didExpandIndexChange(_ newIndex: Int) {
    }
}
