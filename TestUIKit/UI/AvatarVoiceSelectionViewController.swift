import UIKit
import SnapKit

final class AvatarVoiceSelectionViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var optionNames: [String] = ["Bright", "Refined", "Sweet"]
    private var selectedIndex: Int = 0

    private let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pick a voice for your avatar"
        lbl.font = .appFont(\.h5)
        lbl.textColor = .appColor(\.black)
        lbl.textAlignment = .center
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appColor(\.white)

        navigationItem.titleView = headerLabel

        setupTableView()
        setupBottomButtons()
    }

    private func setupTableView() {
        tableView.register(AvatarOptionCell.self, forCellReuseIdentifier: AvatarOptionCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }

    private func setupBottomButtons() {
        let bottomContainer = UIView()
        view.addSubview(bottomContainer)

        let finalizeButton = AIAMainButton(style: .filled)
        finalizeButton.setTitle("Finalize your avatar", for: .normal)
        bottomContainer.addSubview(finalizeButton)

        let actionButtonsContainer = UIView()
        bottomContainer.addSubview(actionButtonsContainer)

        bottomContainer.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        finalizeButton.snp.makeConstraints { make in
            make.leading.equalTo(bottomContainer.snp.leading).offset(16)
            make.trailing.equalTo(bottomContainer.snp.trailing).inset(16)
            make.height.equalTo(56)
            make.bottom.equalTo(bottomContainer.snp.bottom).inset(16)
        }

        actionButtonsContainer.snp.makeConstraints { make in
            make.leading.equalTo(bottomContainer.snp.leading)
            make.trailing.equalTo(bottomContainer.snp.trailing)
            make.bottom.equalTo(finalizeButton.snp.top).offset(-24)
            make.top.equalTo(bottomContainer.snp.top)
        }

        let recordButton = createCircularButton(systemName: "mic.fill", title: "Record")
        let uploadButton = createCircularButton(systemName: "square.and.arrow.up", title: "Upload")

        actionButtonsContainer.addSubview(recordButton)
        actionButtonsContainer.addSubview(uploadButton)

        let horizontalInset: CGFloat = 64
        let interItemSpacing: CGFloat = 64
        let verticalInset: CGFloat = 48

        recordButton.snp.makeConstraints { make in
            make.leading.equalTo(actionButtonsContainer.snp.leading).offset(horizontalInset)
            make.top.equalTo(actionButtonsContainer.snp.top).offset(8)
            make.bottom.equalTo(actionButtonsContainer.snp.bottom).inset(verticalInset)
            make.trailing.equalTo(uploadButton.snp.leading).offset(-interItemSpacing)
            make.width.equalTo(uploadButton)
        }

        uploadButton.snp.makeConstraints { make in
            make.trailing.equalTo(actionButtonsContainer.snp.trailing).inset(horizontalInset)
            make.top.equalTo(actionButtonsContainer.snp.top).offset(8)
            make.bottom.equalTo(actionButtonsContainer.snp.bottom).inset(verticalInset)
        }

        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomContainer.snp.top)
        }
    }

    private func createCircularButton(systemName: String, title: String) -> UIControl {
        let container = UIControl()

        let circle = UIView()
        circle.layer.cornerRadius = 36
        circle.layer.borderWidth = 1
        circle.layer.borderColor = UIColor.appColor(\.middleGray).cgColor
        circle.backgroundColor = .appColor(\.white)

        let imageView = UIImageView(image: UIImage(systemName: systemName))
        imageView.tintColor = .appColor(\.darkGray)

        let label = UILabel()
        label.text = title
        label.font = .appFont(\.body2M)
        label.textColor = .appColor(\.inactiveGray2)

        container.addSubview(circle)
        circle.addSubview(imageView)
        container.addSubview(label)

        circle.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top)
            make.centerX.equalTo(container.snp.centerX)
            make.width.height.equalTo(72)
        }

        imageView.snp.makeConstraints { make in
            make.center.equalTo(circle.snp.center)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(circle.snp.bottom).offset(8)
            make.centerX.equalTo(container.snp.centerX)
            make.bottom.equalTo(container.snp.bottom)
        }

        return container
    }
}

extension AvatarVoiceSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AvatarOptionCell.reuseIdentifier, for: indexPath) as? AvatarOptionCell else {
            return UITableViewCell()
        }
        let name = optionNames[indexPath.row]
        cell.configure(title: name, selected: indexPath.row == selectedIndex)
        cell.setOnSelect { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = indexPath.row
            self.tableView.reloadData()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
