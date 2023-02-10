import UIKit
import SafariServices

final class SettingViewController: UIViewController {
    
    private let viewModel: SettingViewModel
    
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var profileImageView: UIImageView = {
        let photo = UIImageView()
        photo.clipsToBounds = true
        photo.contentMode = .scaleAspectFit
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = 130 / 2
        photo.tintColor = .lightGray
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.borderWidth = 2
        photo.image = UIImage(systemName: "person.fill")
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private lazy var accessAccountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Acesse sua conta\nou cadastre-se"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didOpenLink))
        view.addGestureRecognizer(gesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buildSetup()
    }
    
    @objc
    private func didOpenLink() {
        guard let url = URL(string: viewModel.openSignInLink()) else { return }
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true)
    }
}

extension SettingViewController: ViewConfiguration {
    func buildHierarchyView() {
        containerStackView.addArrangedSubview(profileImageView)
        containerStackView.addArrangedSubview(accessAccountLabel)
        
        view.addSubview(containerStackView)
    }
    
    func activeConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            containerStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: containerStackView.trailingAnchor, multiplier: 1),
            
            profileImageView.heightAnchor.constraint(equalToConstant: ImageSize.profileImageHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: ImageSize.profileImageWidth)
        ])
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

private extension SettingViewController {
    enum ImageSize {
        static let profileImageHeight: CGFloat = 130
        static let profileImageWidth: CGFloat = 130
    }
}
