import UIKit
import AVFoundation
import SnapKit

class VideoPlayerViewController: UIViewController {

    // MARK: - Properties
    var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // MARK: - UI Elements
    let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()

    private let videoView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()

    private let fullscreenButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        btn.layer.cornerRadius = 20
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoView.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //player?.pause()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .yellow
        view.addSubview(containerView)
        containerView.addSubview(videoView)
        view.addSubview(fullscreenButton)

        fullscreenButton.addTarget(self, action: #selector(openFullscreen), for: .touchUpInside)

        // Container inset 20pt from safe area on all sides
        containerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        // videoView fills entire screen but lives inside containerView
        videoView.snp.makeConstraints {
            $0.center.equalTo(containerView)
            $0.width.equalTo(view)
            $0.height.equalTo(view)
        }

        // Fullscreen button bottom-right of safe area
        fullscreenButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(40)
        }
    }
    
    func containerViewFillScreen() {
        containerView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Setup AVPlayer
    private func setupPlayer() {
        let urlStr = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        guard let url = URL(string: urlStr) else { return }

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer!)

        NotificationCenter.default.addObserver(
            self, selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime, object: item
        )

        player?.play()
    }

    // MARK: - Fullscreen
    @objc private func openFullscreen() {
        containerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.26, delay: 0, options: .curveEaseInOut, animations: {
            self.containerView.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self, let player else { return }
            //self.videoView.alpha = 0
            let vc = FullScreenPlayerViewController(player: player, playerLayer: playerLayer)
            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
            
            present(vc, animated: true)
            vc.onDismiss = { [weak self] in
                guard let self = self else { return }
                self.videoView.layer.addSublayer(playerLayer!)
                self.containerView.snp.remakeConstraints {
                    $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
                }
                UIView.animate(withDuration: 0.26, animations: {
                    self.containerView.layoutIfNeeded()
                })
            }
        })
        
    }

    // MARK: - Loop
    @objc private func videoDidEnd() {
        player?.seek(to: .zero)
        player?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
