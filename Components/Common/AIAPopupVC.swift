//
//  AIAPopupVC.swift
//  Components
//
//  Created by Duck Sern on 18/6/25.
//  Copyright © 2025 BlueBelt. All rights reserved.
//

import UIKit
import SnapKit

open class AIAPopupVC: UIViewController {
    deinit {
        debugPrint("\(String(describing: type(of: self))) 🧹Deinit")
    }
    
    public var onUserDismissAction: (() -> Void)?
    public var showGrabView: Bool = true
    public var dismissType: AIABottomSheetVC.DismissType = .dismissible
    public var backgroundAlpha: CGFloat = 0.5
    
    private var isUserTapBackgroundToDismiss = false
    private lazy var transitionAnimator = PopupAnimatedTransitioning()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isUserTapBackgroundToDismiss {
            onUserDismissAction?()
        }
    }
    
    public func toggleContentIfCurrentlyPresent(_ isShow: Bool) {
        guard presentingViewController != nil,
            let presentationController = presentationController as? DimBackgroundPresentationController else { return }
        presentationController.showBackground(isShow)
        view.isHidden = !isShow
    }
    
    // only support for `dismissType` == `tapToDismiss` | `dismissible`
    public func setEnableTapBackgroundToDismiss(_ isEnable: Bool) {
        guard presentingViewController != nil,
            let presentationController = presentationController as? DimBackgroundPresentationController,
              dismissType == .tapToDismiss || dismissType == .dismissible
        else { return }
        presentationController.bindEnableTapGR(isEnable)
    }
}

extension AIAPopupVC: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transitionAnimator.state = .present
        return transitionAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transitionAnimator.state = .dismiss
        return transitionAnimator
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

fileprivate final class PopupAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    enum State {
        case present
        case dismiss
    }
    var state: State = .present
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        switch state {
        case .present:
            let toView = transitionContext.view(forKey: .to)!
            toView.layer.cornerRadius = 30
            toView.layer.masksToBounds = true
            transitionContext.containerView.addSubview(toView)
            toView.snp.makeConstraints { make in
                make.directionalHorizontalEdges.equalToSuperview().inset(30)
                make.centerY.equalToSuperview()
                make.top.lessThanOrEqualTo(transitionContext.containerView.safeAreaLayoutGuide).inset(20).priority(50)
                make.bottom.greaterThanOrEqualTo(transitionContext.containerView.safeAreaLayoutGuide).inset(20).priority(50)
            }
            toView.alpha = 0
            toView.transform = .identity.scaledBy(x: 0.1, y: 0.1)
            UIView.animate(withDuration: duration) {
                toView.alpha = 1
                toView.transform = .identity
            } completion: { isComplete in
                transitionContext.completeTransition(isComplete)
            }
        case .dismiss:
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: duration) {
                fromView.alpha = 0
                fromView.transform = .identity.scaledBy(x: 0.1, y: 0.1)
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
    private lazy var tapGR = UITapGestureRecognizer()
    
    override var shouldPresentInFullscreen: Bool {
        false
    }
    
    override var shouldRemovePresentersView: Bool {
        false
    }
    
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
    
    override var frameOfPresentedViewInContainerView: CGRect {
        .init(origin: .init(x: 100, y: 100), size: .init(width: 200, height: 200))
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
    
    func bindEnableTapGR(_ isEnable: Bool) {
        tapGR.isEnabled = isEnable
    }
}
