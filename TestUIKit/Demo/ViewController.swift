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

protocol SubView: UIView {
    func makePropertyAnimator() -> UIViewPropertyAnimator
}

class Cell: ScrollableSingleSectionItemView {
    private let orangeRect = UIView()
    override func showContent() {
        orangeRect.alpha = 1
    }
    
    override func hideContent() {
        orangeRect.alpha = 0
    }
    
    let imgView = UIView()
    let label = UILabel()
    let topSepe = UIView()
    let bottomSepe = UIView()
    static let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .brown, .gray, .magenta]
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(label)
        orangeRect.backgroundColor = .orange
        addSubview(orangeRect)
        orangeRect.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(20)
            make.height.width.equalTo(50)
        }
        label.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
        label.textColor = .white
        label.font = .systemFont(ofSize: 26, weight: .semibold)
    }
}

