import UIKit
import AVFoundation
import SnapKit
import Combine

class FullScreenPlayerViewController: UIViewController {

    private var playerLayer: AVPlayerLayer
    private var maskFrame: CGRect
    
    private lazy var transitionAnimator = VideoAnimatedTransitioning()
    
    var onDismiss: (() -> Void)?
    var onVideoLayerReady: (() -> Void)?

    private let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        btn.layer.cornerRadius = 20
        return btn
    }()

    // MARK: - Init
    init(playerLayer: AVPlayerLayer, maskFrame: CGRect) {
        self.playerLayer = playerLayer
        self.maskFrame = maskFrame
        super.init(nibName: nil, bundle: nil)
        self.transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupDismissButton()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //player.pause()
    }

    private func setupDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(40)
        }
    }
    
    var cancellable: AnyCancellable?

    @objc private func dismissVC() {
        dismiss(animated: true, completion: onDismiss)
    }
    
    // MARK: - Setup AVPlayer
    private func setupPlayer() {
        playerLayer.frame = view.bounds
        view.layer.insertSublayer(playerLayer, at: 0)
    }
    
    deinit {
        //player.pause()
        cancellable?.cancel()
    }
}

extension FullScreenPlayerViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transitionAnimator.state = .present
        transitionAnimator.maskFrame = maskFrame
        return transitionAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transitionAnimator.state = .dismiss
        return transitionAnimator
    }
}

fileprivate final class VideoAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    enum State {
        case present
        case dismiss
    }
    var state: State = .present
    var maskFrame: CGRect = .zero
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        switch state {
        case .present:
            let toView = transitionContext.view(forKey: .to)!
            let mask = UIView()
            mask.backgroundColor = .black
            mask.frame = maskFrame
            mask.layer.cornerRadius = 20
            mask.clipsToBounds = true
            toView.mask = mask
            transitionContext.containerView.addSubview(toView)
            toView.frame = transitionContext.containerView.bounds
            UIView.animate(withDuration: 0.26, animations: {
                mask.frame = transitionContext.containerView.bounds
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        case .dismiss:
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: duration) {
                fromView.mask?.frame = self.maskFrame
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
