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
//        v.backgroundColor = .red
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
        setupUI()
        setupPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("SERN :: ", view.safeAreaLayoutGuide.frame(in: view)?.insetBy(dx: 20, dy: 20) ?? .zero)
        playerLayer?.frame = view.bounds
        videoView.mask!.frame = view.safeAreaLayoutGuide.frame(in: view)?.insetBy(dx: 20, dy: 20) ?? .zero
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //player?.pause()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .yellow

        view.addSubview(videoView)
        view.addSubview(fullscreenButton)

        fullscreenButton.addTarget(self, action: #selector(openFullscreen), for: .touchUpInside)

        // Container inset 20pt from safe area on all sides
        videoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        let mask = UIView()
        mask.layer.cornerRadius = 20
        mask.clipsToBounds = true
//        mask.frame = .init(x: 100, y: 100, width: 200, height: 200)
        mask.backgroundColor = .black
        videoView.mask = mask

        NotificationCenter.default.addObserver(
            self, selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime, object: item
        )

        player?.play()
    }

    // MARK: - Fullscreen
    @objc private func openFullscreen() {
        let vc = FullScreenPlayerViewController(playerLayer: playerLayer!, maskFrame: videoView.mask!.frame)
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
        vc.onDismiss = { [weak self] in
            guard let self = self else { return }
            self.videoView.layer.addSublayer(playerLayer!)
        }
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
