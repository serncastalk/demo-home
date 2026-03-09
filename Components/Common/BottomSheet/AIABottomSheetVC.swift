//
//  AIABottomSheetVC.swift
//  Components
//
//  Created by Duck Sern on 18/6/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

open class AIABottomSheetVC: UIViewController {
    deinit {
        debugPrint("\(String(describing: type(of: self))) 🧹Deinit")
    }
    
    public enum DismissType {
        ///Cannot dismiss internally
        case none
        
        ///Allow tap & pull to dismiss
        case dismissible
        
        ///Pull to dismiss only
        case pullToDismiss
        
        ///Tap on background to dismiss only
        case tapToDismiss
    }
    
    open var trackingScrollView: UIScrollView? { nil }
    
    public var onUserDismissAction: (() -> Void)?
    public var showGrabView: Bool = true
    public var dismissType: DismissType = .dismissible
    public var backgroundAlpha: CGFloat = 0.5
    
    private var isInteractiveDismiss = false
    private var isUserTapBackgroundToDismiss = false
    private var distanceFromFirstTouchToBottomEdge: CGFloat = .zero
    private lazy var dismissHandle = UIPercentDrivenInteractiveTransition()
    private lazy var transitionAnimator = BottomSheetAnimatedTransitioning()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let needAddPanGesture: Bool = switch dismissType {
        case .dismissible, .pullToDismiss: true
        case .none, .tapToDismiss: false
        }
        trackingScrollView?.panGestureRecognizer.addTarget(self, action: #selector(self._onPanTrackingScrollView))
        trackingScrollView?.bounces = false
        if needAddPanGesture {
            let panGR = UIPanGestureRecognizer(target: self, action: #selector(self._onPan))
            //panGR.delegate = self
            view.addGestureRecognizer(panGR)
            if let trackingScrollView {
                panGR.require(toFail: trackingScrollView.panGestureRecognizer)
            }
        }
    }
    
    private var scrollViewYWhenDismiss: CGFloat = .zero
    @objc func _onPanTrackingScrollView(_ pan: UIPanGestureRecognizer) {
        guard let superview = view.superview else { return }
        let velocity = pan.velocity(in: superview).y
        switch pan.state {
        case .began:
            if velocity > 0 && trackingScrollView!.contentOffset.y <= 0 {
                isInteractiveDismiss = true
                distanceFromFirstTouchToBottomEdge = superview.bounds.height - pan.location(in: superview).y
                dismiss(animated: true)
                scrollViewYWhenDismiss = .zero
            } else {
            }
            
        case .changed:
            if isInteractiveDismiss {
                let transitionY = pan.translation(in: superview).y - scrollViewYWhenDismiss
                dismissHandle.update(transitionY / view.bounds.height)
            } else {
                if velocity > 0 {
                    let transitionY = pan.translation(in: superview).y
                    if trackingScrollView!.contentOffset.y <= 0 {
                        isInteractiveDismiss = true
                        distanceFromFirstTouchToBottomEdge = superview.bounds.height - pan.location(in: superview).y
                        scrollViewYWhenDismiss = transitionY
                        dismiss(animated: true)
                    }
                }
            }
            
        case .ended:
            let transitionY = pan.translation(in: superview).y
            if isInteractiveDismiss {
                if velocity > 0 {
                    if transitionY < distanceFromFirstTouchToBottomEdge / 2 {
                        isInteractiveDismiss = false
                        dismissHandle.cancel()
                    } else {
                        dismissHandle.finish()
                    }
                } else {
                    isInteractiveDismiss = false
                    dismissHandle.cancel()
                }
            }
            
        case .cancelled:
            if isInteractiveDismiss {
                isInteractiveDismiss = false
                dismissHandle.cancel()
            }
        default:
            break
        }
    }
    
    @objc func _onPan(_ pan: UIPanGestureRecognizer) {
        guard let superview = view.superview else { return }
        let velocity = pan.velocity(in: superview).y
        switch pan.state {
        case .began:
            if velocity > 0 {
                isInteractiveDismiss = true
                distanceFromFirstTouchToBottomEdge = superview.bounds.height - pan.location(in: superview).y
                dismiss(animated: true)
            } else {
                pan.state = .cancelled
            }
        case .changed:
            let transitionY = pan.translation(in: superview).y
            dismissHandle.update(transitionY / view.bounds.height)
        case .ended:
            let transitionY = pan.translation(in: superview).y
            if velocity > 0 {
                if transitionY < distanceFromFirstTouchToBottomEdge / 2 {
                    isInteractiveDismiss = false
                    trackingScrollView?.isScrollEnabled = true
                    dismissHandle.cancel()
                } else {
                    dismissHandle.finish()
                }
            } else {
                isInteractiveDismiss = false
                trackingScrollView?.isScrollEnabled = true
                dismissHandle.cancel()
            }
        case .cancelled:
            isInteractiveDismiss = false
            trackingScrollView?.isScrollEnabled = true
            dismissHandle.cancel()
        default:
            break
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isInteractiveDismiss || isUserTapBackgroundToDismiss {
            onUserDismissAction?()
        }
    }
    
    public func toggleContentIfCurrentlyPresent(_ isShow: Bool) {
        guard presentingViewController != nil,
            let presentationController = presentationController as? DimBackgroundPresentationController else { return }
        presentationController.showBackground(isShow)
        view.isHidden = !isShow
    }
}

extension AIABottomSheetVC: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let trackingScrollView else { return true }
        let velocityScroll = trackingScrollView.panGestureRecognizer.velocity(in: trackingScrollView.superview!).y
        if trackingScrollView.contentOffset.y <= 0 && velocityScroll >= 0 {
            trackingScrollView.isScrollEnabled = false
            return true
        } else {
            return false
        }
    }
}

extension AIABottomSheetVC: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transitionAnimator.state = .present(showGrabView: showGrabView)
        return transitionAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transitionAnimator.state = .dismiss
        return transitionAnimator
    }
    
    public func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        if isInteractiveDismiss {
            isInteractiveDismiss = true
            return dismissHandle
        } else {
            return nil
        }
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        DimBackgroundPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            dismissType: dismissType,
            backgroundAlpha: backgroundAlpha,
            onTapBackground: { [weak self] in
                self?.isUserTapBackgroundToDismiss = true
            })
    }
}

fileprivate final class BottomSheetAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    enum State {
        case present(showGrabView: Bool)
        case dismiss
    }
    var state: State = .present(showGrabView: true)
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        switch state {
        case let .present(showGrabView):
            let toView = transitionContext.view(forKey: .to)!
            toView.layer.cornerRadius = 30
            toView.layer.masksToBounds = true
            toView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            let grabView = {
                let v = UIView()
                v.backgroundColor = .appColor(\.middleGray)
                v.layer.cornerRadius = 3
                v.clipsToBounds = true
                return v
            }()
            transitionContext.containerView.addSubview(toView)
            toView.snp.makeConstraints { make in
                make.bottom.directionalHorizontalEdges.equalToSuperview()
                make.height.lessThanOrEqualTo(UIScreen.main.bounds.height * 0.85)
                make.top.greaterThanOrEqualTo(transitionContext.containerView.safeAreaLayoutGuide)
            }
            if showGrabView {
                toView.addSubview(grabView)
                grabView.snp.makeConstraints { make in
                    make.top.equalTo(toView.snp.top).inset(4)
                    make.centerX.equalTo(toView)
                    make.width.equalTo(48)
                    make.height.equalTo(6)
                }
            }
            toView.transform = .identity.translatedBy(x: 0, y: UIScreen.main.bounds.height)
            UIView.animate(withDuration: duration) {
                toView.transform = .identity
            } completion: { isComplete in
                transitionContext.completeTransition(isComplete)
            }
        case .dismiss:
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: duration) {
                fromView.transform = .identity.translatedBy(x: 0, y: fromView.bounds.height)
            } completion: { isComplete in
                let isCompleteTransition = isComplete && !transitionContext.transitionWasCancelled
                if isCompleteTransition {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(isCompleteTransition)
            }
        }
    }
    
}

fileprivate final class DimBackgroundPresentationController: UIPresentationController {
    private lazy var backgroundView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0
        return v
    }()
    private let dismissType: AIABottomSheetVC.DismissType
    private let backgroundAlpha: CGFloat
    private let onTapBackground: (() -> Void)?
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         dismissType: AIABottomSheetVC.DismissType,
         backgroundAlpha: CGFloat,
         onTapBackground: (() -> Void)?) {
        self.dismissType = dismissType
        self.backgroundAlpha = backgroundAlpha
        self.onTapBackground = onTapBackground
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(backgroundView)
        let needAddTapGesture: Bool = switch dismissType {
        case .dismissible, .tapToDismiss: true
        case .none, .pullToDismiss: false
        }
        let tapGR = UITapGestureRecognizer()
        tapGR.isEnabled = needAddTapGesture
        tapGR.addTarget(self, action: #selector(self._onTap))
        backgroundView.addGestureRecognizer(tapGR)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            self.backgroundView.alpha = self.backgroundAlpha
        })
    }
    
    @objc private func _onTap() {
        onTapBackground?()
        presentedViewController.dismiss(animated: true)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            self.backgroundView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            backgroundView.removeFromSuperview()
        }
    }
    
    func showBackground(_ isShow: Bool) {
        backgroundView.isHidden = !isShow
    }
}
