import UIKit

protocol FeedTableViewCellDelegate: AnyObject {
    func update(index: IndexPath)
}

final class FeedTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier: String = FeedTableViewCell.self.description()
    weak var delegate: FeedTableViewCellDelegate?
    
    var indexPath: IndexPath?
    var imageDisplaying: String?
    
    private var dataTask: URLSessionDataTask?
    private lazy var iconHeight = iconImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)

    // MARK: - Components
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .darkGray
        container.layer.masksToBounds = true
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var titleLabel = makeLabel(font: .systemFont(ofSize: FontSize.title, weight: .bold), textColor: .label)

    private lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        icon.layer.masksToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var descriptionLabel = makeLabel(font: .systemFont(ofSize: FontSize.description, weight: .regular), textColor: .lightGray)
    private lazy var subDescriptionLabel = makeLabel(font: .systemFont(ofSize: FontSize.subDescription, weight: .semibold), textColor: .systemRed)
    private lazy var elapsedTimeLabel = makeLabel(font: .systemFont(ofSize: FontSize.elapsedTime, weight: .semibold), textColor: .label)
    
    // MARK: - Life Cicle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildSetup()
    }

    override func prepareForReuse() {
        dataTask?.cancel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func setup(for item : FeedItemCellViewModel) {
        titleLabel.text = item.titleText()
        descriptionLabel.text = item.summaryText()
        subDescriptionLabel.text = item.hatText()
        elapsedTimeLabel.text = item.formatAge()
        downloadImageBasedOn(url: item.getIcon())
    }
    
    private func downloadImageBasedOn(url: URL?) {
        guard let url = url else { return setImage(image: nil) }
        
        guard imageDisplaying != url.path else { return }
        imageDisplaying = url.path
        setImage(image: nil)
        
        dataTask = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in                
                guard let icon = UIImage(data: data), icon != UIImage() else {
                    self?.setImage(image: nil, shouldUpdateCell: true)
                    return
                }
            
                guard let iconHeight = self?.iconHeight else { return }
                self?.iconImageView.addConstraint(iconHeight)
                self?.setImage(image: icon, shouldUpdateCell: true)
            }
        })
        dataTask?.resume()
    }
    
    private func setImage(image: UIImage?, shouldUpdateCell: Bool = false) {
        iconImageView.image = image
        let constant: CGFloat = image == nil ? 0 : 170
        makeIconHeight(constant: constant, shouldUpdateCell: true)
    }
    
    private func makeIconHeight(constant: CGFloat, shouldUpdateCell: Bool = false) {
        guard iconHeight.constant != constant else { return }
        iconHeight.isActive = false
        iconHeight = iconImageView.heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        iconHeight.isActive = true
        guard shouldUpdateCell else { return }
        updateCellHeight()
    }
    
    private func updateCellHeight() {
        guard let indexPath = indexPath else { return }
        delegate?.update(index: indexPath)
    }
}

extension FeedTableViewCell: ViewConfiguration {
    func buildHierarchyView() {
        contentView.add(subviews: stackView)

        stackView.add(arrangeSubview:
            titleLabel,
            iconImageView,
            descriptionLabel,
            subDescriptionLabel,
            elapsedTimeLabel
        )
    }
    
    func activeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2)
        ])
    }
}

private extension FeedTableViewCell {
    func makeLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.numberOfLines = 0
        label.font = font
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    enum FontSize {
        static let title: CGFloat = 20
        static let description: CGFloat = 16
        static let subDescription: CGFloat = 12
        static let elapsedTime: CGFloat = 12
    }
}
