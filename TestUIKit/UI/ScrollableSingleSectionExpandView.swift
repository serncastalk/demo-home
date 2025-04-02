//
//  ScrollableSingleSectionExpandView.swift
//  TestUIKit
//
//  Created by Duck Sern on 1/4/25.
//

import UIKit

protocol ScrollableSingleSectionExpandViewDataSource: AnyObject {
    func numberOfItems() -> Int
    func newItemView() -> ScrollableSingleSectionItemView
    func configItemView(_ item: ScrollableSingleSectionItemView, index: Int)
}

protocol ScrollableSingleSectionExpandViewDelegate: AnyObject {
    func didTapOnExpandItem(index: Int)
    func didExpandIndexChange(_ newIndex: Int)
}

class ScrollableSingleSectionExpandView: UIView {
    struct Config {
        var numberItemsInScreen: Int = 2
        var percentSmallItems: CGFloat = 0.2
    }
    
    weak var dataSource: ScrollableSingleSectionExpandViewDataSource!
    weak var delegate: ScrollableSingleSectionExpandViewDelegate!
    
    private var config: Config = .init()
    private var queue: [ScrollableSingleSectionItemView] = []
    public var currListIndex = 0 {
        didSet {
            onUpdateCurrentIndex(oldValue: oldValue, newValue: currListIndex)
        }
    }
    
    private var maxItemsRender: Int = 0
    private var expandSize: CGFloat = 0.0
    private var collapseSize: CGFloat = 0.0
    private var oldHeight: CGFloat = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard oldHeight != bounds.height else { return }
        let bigItemPercent = 1 - CGFloat(config.numberItemsInScreen - 1) * config.percentSmallItems
        expandSize = bounds.height * bigItemPercent
        collapseSize = bounds.height * config.percentSmallItems
        oldHeight = bounds.height
        initData()
    }
    
    private func setup() {
        clipsToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onPan))
        addGestureRecognizer(panGesture)
    }
    
    func bind(config: Config) {
        self.config = config
        // one item on top, one item at bottom
        maxItemsRender = 1 + config.numberItemsInScreen + 1
    }
    
    private func initData() {
        let numberOfItems = dataSource.numberOfItems()
        guard numberOfItems > 0 else { return }
        for v in subviews {
            v.removeFromSuperview()
        }
        let nextItemsCount = min(maxItemsRender - 1, numberOfItems)
        for i in 0..<nextItemsCount {
            let v = createView(index: i)
            if i == 0 {
                v.showContent()
            } else {
                v.hideContent()
            }
            dataSource.configItemView(v, index: i)
            insertSubview(v, at: 0)
        }
    }
    
    func onUpdateCurrentIndex(oldValue: Int, newValue: Int) {
        let isUp = newValue > oldValue
        if isUp {
            //remove first subview if container has 6 subviews
            //add subviews to bottom of list
            //TODO: CHECK AGAIN
            if currListIndex > 1 {
                let firstSubView = subviews.last! as! ScrollableSingleSectionItemView
                firstSubView.removeFromSuperview()
                queue.append(firstSubView)
            }
            let numberOfItems = dataSource.numberOfItems()
            let nextItemIndex = currListIndex + config.numberItemsInScreen
            guard nextItemIndex < numberOfItems else { return }
            let v = createView(index: nextItemIndex)
            dataSource.configItemView(v, index: nextItemIndex)
            insertSubview(v, at: 0)
            
        } else {
            //remove last subview
            if canRemoveLastItem() {
                let lastSubView = subviews.first! as! ScrollableSingleSectionItemView
                lastSubView.removeFromSuperview()
                queue.append(lastSubView)
            }
            //add subviews to top of list
            let prevItemIndex = currListIndex - 1
            guard prevItemIndex >= 0 else { return }
            let v = createView(index: prevItemIndex)
            dataSource.configItemView(v, index: prevItemIndex)
            addSubview(v)
            v.transform = .identity.translatedBy(x: 0, y: 0 - (expandSize - collapseSize))
        }
        delegate.didExpandIndexChange(newValue)
    }
    
    private func canRemoveLastItem() -> Bool {
        let numberOfItems = dataSource.numberOfItems()
        return currListIndex + config.numberItemsInScreen < numberOfItems - 1
    }
    
    private func createView(index i: Int) -> ScrollableSingleSectionItemView {
        let numberOfItems = dataSource.numberOfItems()
        let v = dequeueView()
        v.hideContent()
        var _height = expandSize
        //last item
        if i == numberOfItems - 1 {
            _height = bounds.height
        }
        v.index = i
        v.frame = .init(x: 0, y: CGFloat(i) * collapseSize, width: bounds.width, height: _height)
        v.onTap = { [weak self] viewIndex in
            guard let self = self else { return }
            if viewIndex == self.currListIndex {
                self.delegate.didTapOnExpandItem(index: viewIndex)
            } else {
                self.scrollUp()
            }
        }
        return v
    }
    
    private func dequeueView() -> ScrollableSingleSectionItemView {
        let v: ScrollableSingleSectionItemView
        if let first = queue.first {
            v = first
            queue.removeFirst()
        } else {
            v = dataSource.newItemView()
        }
        v.transform = .identity
        return v
    }
    
    private var currAnimator: UIViewPropertyAnimator?
    private var beganPoint: CGPoint = .zero
    private var isUserScrollingUp: Bool?
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        let translateY = pan.translation(in: self.superview!).y
        switch pan.state {
        case .began:
            beganPoint = pan.location(in: self.superview!)
        case .changed:
            let currPoint = pan.location(in: self.superview!)
            let isScrollUp = currPoint.y < beganPoint.y
            if isScrollUp != isUserScrollingUp {
                isUserScrollingUp = isScrollUp
                currAnimator?.stopAnimation(true)
                currAnimator = createScrollAnimator()
            }
            let screenHeight = UIScreen.main.bounds.height
            currAnimator?.fractionComplete = abs(translateY / screenHeight)
        case .ended:
            currAnimator?.startAnimation()
        case .cancelled:
            break
        default:
            break
        }
    }
    
    private var prevBigView: ScrollableSingleSectionItemView? {
        if currListIndex == 0 {
            return nil
        } else {
            return subviews.last as? ScrollableSingleSectionItemView
        }
    }
    
    private var currBigView: ScrollableSingleSectionItemView {
        if currListIndex == 0 {
            return subviews.last! as! ScrollableSingleSectionItemView
        } else {
            let count = subviews.count
            return subviews[count - 2] as! ScrollableSingleSectionItemView
        }
    }
    
    private var nextBigView: ScrollableSingleSectionItemView {
        let count = subviews.count
        if currListIndex == 0 {
            return subviews[count - 2] as! ScrollableSingleSectionItemView
        } else {
            return subviews[count - 3] as! ScrollableSingleSectionItemView
        }
    }
    
    private func createScrollAnimator() -> UIViewPropertyAnimator? {
        guard let isUserScrollingUp else { return nil }
        if isUserScrollingUp {
            return createScrollUpAnimator()
        } else {
            return createScrollDownAnimator()
        }
    }
    
    func scrollUp() {
        let animator = createScrollUpAnimator()
        animator?.startAnimation()
    }
    
    private func createScrollUpAnimator() -> UIViewPropertyAnimator? {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            let currBigView = self.currBigView
            currBigView.hideContent()
            let height = currBigView.bounds.height
            currBigView.transform = .identity.translatedBy(x: 0, y: 0 - (height - self.collapseSize))
            self.nextBigView.showContent()
            self.bounds.origin.y = CGFloat(self.currListIndex + 1) * self.collapseSize
        }
        animator.addCompletion { [weak self] isComplete in
            guard let self = self else { return }
            self.currListIndex += 1
            self.currAnimator = nil
            self.isUserScrollingUp = nil
        }
        return animator
    }
    
    private func createScrollDownAnimator() -> UIViewPropertyAnimator? {
        guard let prevBigView = prevBigView else { return nil }
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            prevBigView.transform = .identity
            prevBigView.showContent()
            self.currBigView.hideContent()
            self.bounds.origin.y = CGFloat(self.currListIndex - 1) * self.collapseSize
        }
        animator.addCompletion { [weak self] isComplete in
            guard let self = self else { return }
            self.currListIndex -= 1
            self.currAnimator = nil
            self.isUserScrollingUp = nil
        }
        return animator
    }
    /*
    private func onExpand(newIndex: Int) {
        let count = self.subviews.count
        print("COUNT :: ", count)
        var currIndex = count - 1
        if self.currListIndex > 0 {
            currIndex = count - 2
        }
        print("CURRINDE :: ", currIndex)
        let diff = newIndex - self.currListIndex
        let newItemIndex = currIndex - diff
        let needAdd = abs(newItemIndex - diff)
        let newBaseIndex = newIndex + newItemIndex + 1
        print("newBaseIndex = ", newBaseIndex)
        for i in 0..<needAdd {
            let newIndex = newBaseIndex + i
            if newIndex >= dataSource.numberOfItems() {
                break
            }
            let v = createView(index: newIndex)
            v.hideContent()
            dataSource.configItemView(v, index: newIndex)
            insertSubview(v, at: 0)
            currIndex += 1
        }
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            for k in 0..<diff {
                let item = subviews[currIndex - k] as! ScrollableSingleSectionItemView
                item.transform = .identity.translatedBy(x: 0, y: 0 - (self.expandSize - self.collapseSize))
                item.hideContent()
            }
            let nextBigView = subviews[currIndex - diff] as! ScrollableSingleSectionItemView
            nextBigView.showContent()
            self.bounds.origin.y = CGFloat(newIndex) * self.collapseSize
        }
        animator.addCompletion { [weak self] isComplete in
            guard let self = self else { return }
            self.currListIndex = newIndex
        }
        animator.startAnimation()
    }
    
    private func handleAfterExpand() {
        
    }*/
}
