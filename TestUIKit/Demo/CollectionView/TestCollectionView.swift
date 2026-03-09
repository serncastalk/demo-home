//
//  TestCollectionView.swift
//  TestUIKit
//
//  Created by Duck Sern on 10/12/25.
//

import UIKit
import SnapKit

final class TestCollectionView: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: WaterFallLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.contentInset = .init(top: 20, left: 20, bottom: 0, right: 20)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
        collectionView.register(TestSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TestSectionHeader")
    }
}

final class WaterFallLayout: UICollectionViewFlowLayout {
    
    private var contentSize = CGSize.zero
    
    override func prepare() {
        guard let collectionView else {
            super.prepare()
            return
        }
        let newBounds = collectionView.bounds
        let width = newBounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        bigItemWidth = (width - spacing) / 3 * 2
        bigItemHeight = bigItemWidth * 5 / 3
        smallItemWidth = width - bigItemWidth - spacing
        smallItemHeight = (bigItemHeight - spacing) / 2
        setupAttributes()
        let lastSection = allAttributes.last
        let lastCount = lastSection?.count ?? 0
        var height: CGFloat = .zero
        
        for i in 0..<min(lastCount, 3) {
            height = max(height, lastSection?[lastCount - 1 - i].frame.maxY ?? 0)
        }
        
        contentSize = CGSize(width: width, height: height)
    }
    
    private var allAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    private let spacing: CGFloat = 16
    private var bigItemWidth: CGFloat = 0
    private var bigItemHeight: CGFloat = 0
    private var smallItemWidth: CGFloat = 0
    private var smallItemHeight: CGFloat = 0
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        bigItemWidth = (newBounds.width - spacing) / 3 * 2
        bigItemHeight = bigItemWidth * 5 / 3
        smallItemWidth = newBounds.width - bigItemWidth
        smallItemHeight = (bigItemHeight - spacing) / 2
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }

    private func setupAttributes() {
        // 1
        allAttributes = []

        var yOffset: CGFloat = 0

        // 2
        for row in 0..<rowsCount {
            // 3
            var rowAttrs: [UICollectionViewLayoutAttributes] = []
            // 4
            let colCount = columnsCount(in: row)
            for col in 0..<colCount {
                let isBigItem = col % 3 == 0
                let itemYOffset: CGFloat = {
                    switch col % 3 {
                    case 0:
                        return yOffset
                    case 1:
                        return yOffset
                    case 2:
                        return yOffset + smallItemHeight + spacing
                    default:
                        return 0
                    }
                }()
                let itemXOffset: CGFloat = {
                    let group = col / 3
                    // group = 0 -> big item on the right
                    // group = 1 -> big item on the left
                    if group % 2 == 0 {
                        switch col % 3 {
                        case 0:
                            return 0
                        case 1:
                            return bigItemWidth + spacing
                        case 2:
                            return bigItemWidth + spacing
                        default:
                            return 0
                        }
                    } else {
                        switch col % 3 {
                        case 0:
                            return smallItemWidth + spacing
                        case 1:
                            return 0
                        case 2:
                            return 0
                        default:
                            return 0
                        }
                    }
                    
                }()
                let indexPath = IndexPath(row: col, section: row)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(
                    x: itemXOffset,
                    y: itemYOffset,
                    width: isBigItem ? bigItemWidth : smallItemWidth,
                    height: isBigItem ? bigItemHeight : smallItemHeight
                )
                .integral

                rowAttrs.append(attributes)
                if col % 3 == 2 {
                    yOffset += bigItemHeight + spacing
                }
            }
            allAttributes.append(rowAttrs)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return allAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

            for rowAttrs in allAttributes {
                for itemAttrs in rowAttrs where rect.intersects(itemAttrs.frame) {
                    layoutAttributes.append(itemAttrs)
                }
            }

            return layoutAttributes
    }
    
    private var rowsCount: Int {
        return collectionView!.numberOfSections
    }

    private func columnsCount(in row: Int) -> Int {
        return collectionView!.numberOfItems(inSection: row)
    }
    
    override var collectionViewContentSize: CGSize {
        contentSize
    }
}

class TestCell: UICollectionViewCell {
    
}

class TestSectionHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView()
        view.backgroundColor = .green
        addSubview(view)
        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        11
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 50)
    }
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TestSectionHeader", for: indexPath)
        return view
    }*/
}

