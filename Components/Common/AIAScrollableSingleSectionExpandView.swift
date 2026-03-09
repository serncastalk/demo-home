//
//  ScrollableSingleSectionExpandView.swift
//  TestUIKit
//
//  Created by Duck Sern on 1/4/25.
//

import UIKit

public protocol AIAScrollableSingleSectionExpandViewDataSource: AnyObject {
    func numberOfItems() -> Int
    func cellForItem(index: Int) -> AIAScrollableSingleSectionItemView
}

public protocol AIAScrollableSingleSectionExpandViewDelegate: AnyObject {
    func didTapOnExpandItem(item: AIAScrollableSingleSectionItemView, index: Int)
    func didExpandIndexChange(item: AIAScrollableSingleSectionItemView, _ newIndex: Int)
}

public final class AIAScrollableSingleSectionExpandView: UIView {
    private static let ANIMATION_DURATION: TimeInterval = 0.25
    
    public struct Config {
        var numberItemsInScreen: Int = 2
        var percentSmallItems: CGFloat = 0.2
        var collapseSize: CGFloat = .zero
        
        public init(numberItemsInScreen: Int, percentSmallItems: CGFloat, collapseSize: CGFloat = .zero) {
            self.numberItemsInScreen = numberItemsInScreen
            self.percentSmallItems = percentSmallItems
            self.collapseSize = collapseSize
        }
        
        init() {}
    }
    
    public weak var dataSource: AIAScrollableSingleSectionExpandViewDataSource!
    public weak var delegate: AIAScrollableSingleSectionExpandViewDelegate!
    
    private var config: Config = .init()
    public var currListIndex = 0
    
    private var mapItemIdentiferToClass: [String: AIAScrollableSingleSectionItemView.Type] = [:]
    private var queue: [String: [AIAScrollableSingleSectionItemView]] = [:]
    
    private var maxItemsRender: Int = 0
    private var expandSize: CGFloat = 0.0
    private var collapseSize: CGFloat = 0.0
    private var oldHeight: CGFloat = .zero
    private var currentNumberOfItems: Int = .zero
    
    private var isFocus: Bool = false
    private var currentFocusItem: AIAScrollableSingleSectionItemView? {
        guard currListIndex < currentNumberOfItems else { return nil }
        return currBigView
    }
    
    deinit {
        currAnimator?.stopAnimation(true)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard oldHeight != bounds.height else { return }
        if config.collapseSize > .zero {
            expandSize = bounds.height - CGFloat(config.numberItemsInScreen - 1) * config.collapseSize
            collapseSize = config.collapseSize
        } else {
            let bigItemPercent = 1 - CGFloat(config.numberItemsInScreen - 1) * config.percentSmallItems
            expandSize = bounds.height * bigItemPercent
            collapseSize = bounds.height * config.percentSmallItems
        }
        oldHeight = bounds.height
        reloadData()
    }
    
    public func register<T: AIAScrollableSingleSectionItemView>(_ anyClass: T.Type, for identifier: String) {
        mapItemIdentiferToClass[identifier] = anyClass
    }
    
    public func dequeue(for identifier: String, index: Int) -> AIAScrollableSingleSectionItemView {
        guard let view = queue[identifier]?.first else {
            let v = mapItemIdentiferToClass[identifier]!.init()
            v.identifier = identifier
            v.collapseSize = collapseSize
            v.index = index
            return v
        }
        queue[identifier]?.removeFirst()
        view.transform = .identity
        view.collapseSize = collapseSize
        view.identifier = identifier
        view.index = index
        view.prepareForReuse()
        return view
    }
    
    public func focus() {
        isFocus = true
        currentFocusItem?.didFocus()
    }
    
    public func unFocus() {
        isFocus = false
        currentFocusItem?.didLoseFocus()
    }
    
    private func setup() {
        clipsToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onPan))
        addGestureRecognizer(panGesture)
    }
    
    public func bind(config: Config) {
        self.config = config
        // one item on top, one item at bottom
        maxItemsRender = 1 + config.numberItemsInScreen + 1
    }
    
    public func reloadData() {
        currAnimator?.stopAnimation(false)
        currAnimator?.finishAnimation(at: .start)
        currAnimator = nil
        isUserScrollingUp = nil
        
        let numberOfItems = dataSource.numberOfItems()
        for v in subviews {
            removeItemView(v)
        }
        //TODO: Check condition to keep offset
        if currentNumberOfItems > numberOfItems {
            currListIndex = 0
            bounds.origin = .zero
        }
        currentNumberOfItems = numberOfItems
        
        guard currentNumberOfItems > 0 else { return }
        let lastRenderIndex = min(currListIndex + config.numberItemsInScreen, currentNumberOfItems - 1)
        let minIndex = max(currListIndex - 1, 0)
        for i in minIndex...lastRenderIndex {
            let v = createView(index: i)
            if minIndex < currListIndex && i == minIndex {
                v.transform = .identity.translatedBy(x: 0, y: 0 - (expandSize - collapseSize))
            }
            if i == currListIndex {
                v.showContent()
            } else {
                v.didLoseFocus()
                v.hideContent(isUp: false)
            }
            insertSubview(v, at: 0)
        }
        notifyDelegateIndexChange()
    }
    
    func onUpdateCurrentIndex(oldValue: Int, newValue: Int) {
        let isUp = newValue > oldValue
        defer {
            notifyDelegateIndexChange()
        }
        if isUp {
            //remove first subview if container has 6 subviews
            //add subviews to bottom of list
            //TODO: CHECK AGAIN
            if currListIndex > 1 {
                removeItemView(subviews.last)
            }
            let numberOfItems = dataSource.numberOfItems()
            let nextItemIndex = currListIndex + config.numberItemsInScreen
            guard nextItemIndex < numberOfItems else { return }
            let v = createView(index: nextItemIndex)
            insertSubview(v, at: 0)
        } else {
            //remove last subview
            if canRemoveLastItem() {
                removeItemView(subviews.first)
            }
            //add subviews to top of list
            let prevItemIndex = currListIndex - 1
            guard prevItemIndex >= 0 else { return }
            let v = createView(index: prevItemIndex)
            addSubview(v)
            v.transform = .identity.translatedBy(x: 0, y: 0 - (expandSize - collapseSize))
        }
    }
    
    private func notifyDelegateIndexChange() {
        delegate.didExpandIndexChange(item: currBigView, currListIndex)
        if isFocus {
            currBigView.didFocus()
        }
    }
    
    private func removeItemView(_ v: UIView?) {
        guard let v = v as? AIAScrollableSingleSectionItemView else { return }
        v.removeFromSuperview()
        if queue[v.identifier] == nil {
            queue[v.identifier] = []
        }
        queue[v.identifier]!.append(v)
    }
    
    private func canRemoveLastItem() -> Bool {
        let numberOfItems = dataSource.numberOfItems()
        return currListIndex + config.numberItemsInScreen < numberOfItems - 1
    }
    
    private func createView(index i: Int) -> AIAScrollableSingleSectionItemView {
        let numberOfItems = dataSource.numberOfItems()
        let v = dataSource.cellForItem(index: i)
        var _height = expandSize
        //last item
        if i == numberOfItems - 1 {
            _height = bounds.height
        }
        v.index = i
        v.frame = .init(x: 0, y: CGFloat(i) * collapseSize, width: bounds.width, height: _height)
        //last item
        if i == numberOfItems - 1 {
            v.frame = bounds
        }
        v.onTap = { [weak self, weak v] viewIndex in
            guard let self = self,
                  let v = v
            else { return }
            if viewIndex == self.currListIndex {
                self.delegate.didTapOnExpandItem(item: v, index: viewIndex)
            } else {
                self.scrollUp()
            }
        }
        v.hideContent(isUp: i <= currListIndex)
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
            let screenHeight = bounds.height
            currAnimator?.fractionComplete = abs(translateY / screenHeight)
        case .ended:
            isUserScrollingUp = nil
            let currPoint = pan.location(in: self.superview!)
            let veloY = pan.velocity(in: self.superview!).y
            let endYPos = veloY * Self.ANIMATION_DURATION * (1.0 - (currAnimator?.fractionComplete ?? 0)) + currPoint.y
            let isScrollUp = endYPos < beganPoint.y
            if isScrollUp {
                if endYPos >= beganPoint.y / 2 {
                    currAnimator?.isReversed = true
                }
            } else {
                let screenHeight = bounds.height
                if endYPos <= (screenHeight + beganPoint.y) / 2 {
                    currAnimator?.isReversed = true
                }
            }
            currAnimator?.startAnimation()
        case .cancelled:
            isUserScrollingUp = nil
        default:
            break
        }
    }
    
    private var prevBigView: AIAScrollableSingleSectionItemView? {
        if currListIndex == 0 {
            return nil
        } else {
            return subviews.last as? AIAScrollableSingleSectionItemView
        }
    }
    
    private var currBigView: AIAScrollableSingleSectionItemView {
        if currListIndex == 0 {
            return subviews.last! as! AIAScrollableSingleSectionItemView
        } else {
            let count = subviews.count
            return subviews[count - 2] as! AIAScrollableSingleSectionItemView
        }
    }
    
    private var nextBigView: AIAScrollableSingleSectionItemView {
        let count = subviews.count
        if currListIndex == 0 {
            return subviews[count - 2] as! AIAScrollableSingleSectionItemView
        } else {
            return subviews[count - 3] as! AIAScrollableSingleSectionItemView
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
    
    public func scrollUp(animated: Bool = true) {
        let animator = createScrollUpAnimator()
        if !animated {
            animator?.fractionComplete = 1
        }
        animator?.startAnimation()
    }
    
    public func scrollDown(animated: Bool = true) {
        let animator = createScrollDownAnimator()
        if !animated {
            animator?.fractionComplete = 1
        }
        animator?.startAnimation()
    }
    
    private func createScrollUpAnimator() -> UIViewPropertyAnimator? {
        guard currListIndex < dataSource.numberOfItems() - 1 else { return nil }
        let currBigView = self.currBigView
        let animator = UIViewPropertyAnimator(duration: Self.ANIMATION_DURATION, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            currBigView.hideContent(isUp: true)
            let height = currBigView.bounds.height
            currBigView.transform = .identity.translatedBy(x: 0, y: 0 - (height - self.collapseSize))
            self.nextBigView.showContent()
            self.bounds.origin.y = CGFloat(self.currListIndex + 1) * self.collapseSize
            //keep last item stay
            if let lastView = subviews.first as? AIAScrollableSingleSectionItemView,
               lastView.index == self.dataSource.numberOfItems() - 1 {
                lastView.frame.origin = bounds.origin
            }
        }
        animator.isUserInteractionEnabled = false
        animator.addCompletion({ [weak self] position in
            guard let self = self, position == .end else { return }
            self.inCrementIndex()
            currBigView.didLoseFocus()
            self.currAnimator = nil
            self.isUserScrollingUp = nil
        })
        return animator
    }
    
    private func createScrollDownAnimator() -> UIViewPropertyAnimator? {
        guard let prevBigView = prevBigView else { return nil }
        let currBigView = self.currBigView
        let animator = UIViewPropertyAnimator(duration: Self.ANIMATION_DURATION, curve: .easeInOut) { [weak self] in
            guard let self = self else { return }
            prevBigView.transform = .identity
            prevBigView.showContent()
            currBigView.hideContent(isUp: false)
            self.bounds.origin.y = CGFloat(self.currListIndex - 1) * self.collapseSize
            //keep last item stay
            if let lastView = subviews.first as? AIAScrollableSingleSectionItemView,
               lastView.index == self.dataSource.numberOfItems() - 1 {
                lastView.frame.origin = bounds.origin
            }
        }
        animator.isUserInteractionEnabled = false
        animator.addCompletion({ [weak self] position in
            guard let self = self, position == .end else { return }
            self.deCrementIndex()
            currBigView.didLoseFocus()
            self.currAnimator = nil
            self.isUserScrollingUp = nil
        })
        return animator
    }
    
    private func inCrementIndex() {
        let oldValue = currListIndex
        currListIndex += 1
        onUpdateCurrentIndex(oldValue: oldValue, newValue: currListIndex)
    }
    
    private func deCrementIndex() {
        let oldValue = currListIndex
        currListIndex -= 1
        onUpdateCurrentIndex(oldValue: oldValue, newValue: currListIndex)
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
                let item = subviews[currIndex - k] as! AIAScrollableSingleSectionItemView
                item.transform = .identity.translatedBy(x: 0, y: 0 - (self.expandSize - self.collapseSize))
                item.hideContent()
            }
            let nextBigView = subviews[currIndex - diff] as! AIAScrollableSingleSectionItemView
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

public extension AIAScrollableSingleSectionExpandView {
    var visibleItems: [AIAScrollableSingleSectionItemView] {
        var ret: [AIAScrollableSingleSectionItemView] = []
        let maxVisibleIndex = min(currListIndex + config.numberItemsInScreen - 1, currentNumberOfItems - 1)
        guard currListIndex <= maxVisibleIndex else { return [] }
        let setVisibleIndices: Set<Int> = .init(currListIndex...maxVisibleIndex)
        subviews.forEach {
            let v = $0 as! AIAScrollableSingleSectionItemView
            if setVisibleIndices.contains(v.index) {
                ret.append(v)
            }
        }
        return ret
    }
}
