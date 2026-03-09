import UIKit
import AVFoundation
import SnapKit

class FullScreenPlayerViewController: UIViewController {

    // MARK: - Properties
    private let player: AVPlayer
    private var playerLayer: AVPlayerLayer?
    
    private lazy var transitionAnimator = VideoAnimatedTransitioning()
    
    var onDismiss: (() -> Void)?

    private let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        btn.layer.cornerRadius = 20
        return btn
    }()

    // MARK: - Init
    init(player: AVPlayer, playerLayer: AVPlayerLayer?) {
        self.player = player
        self.playerLayer = playerLayer
        super.init(nibName: nil, bundle: nil)
        self.transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPlayer()
        setupDismissButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        playerLayer?.frame = view.bounds
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

    @objc private func dismissVC() {
        dismiss(animated: false, completion: onDismiss)
    }

    // MARK: - Setup
    private func setupPlayer() {
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer?.videoGravity = .resizeAspectFill
//        playerLayer?.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer!)

        //player.play()
    }

    deinit {
        //player.pause()
    }
}

extension FullScreenPlayerViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transitionAnimator.state = .present
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
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        switch state {
        case .present:
            let toView = transitionContext.view(forKey: .to)!
            let toVC = transitionContext.viewController(forKey: .to)!
            toView.frame = transitionContext.finalFrame(for: toVC)
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(true)
        case .dismiss:
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: duration) {
                fromView.alpha = 0
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
