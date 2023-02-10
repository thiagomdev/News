import UIKit
import SafariServices

final class FeedViewController: UIViewController {
    
    private let viewModel: ViewModel
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.dataSource = self
        table.delegate = self
        table.dataSource = self
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.separatorInset = .init(top: Layout.top, left: Layout.left, bottom: Layout.bottom, right: Layout.right)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.separatorColor = .lightGray
        table.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init(viewModel: ViewModel) {
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
        load(page: viewModel.page)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupOnFeedReceived()
    }

    private func load(page: Int) {
        viewModel.fetchData(page: page)
    }
    
    private func setupOnFeedReceived() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc
    private func didTapButton() {
        viewModel.showDetailView()
    }
    
    private func addSettingsNavigationButton() {
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(didTapButton)
        )
    }
}

extension FeedViewController: ViewModelProtocol {
    func showDetailView() {
        let settings = SettingViewController(viewModel: .init())
        navigationController?.pushViewController(settings, animated: true)
    }
    
    func setupOnErrorReceived() {
        viewModel.showServiceError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert", message: "\(String(describing: error))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = viewModel.model[indexPath.row]
        guard let url = URL(string: feed.content.url ?? "") else { return }
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true)
     }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let contenteSize = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offset > contenteSize - height {
            viewModel.page += 1
            load(page: viewModel.page)
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as? FeedTableViewCell else {
            return UITableViewCell()
        }
    
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.delegate = self
        cell.setup(for: .init(model: viewModel.model[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}

extension FeedViewController: FeedTableViewCellDelegate {
    func update(index: IndexPath) {
        tableView.setNeedsDisplay()
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }
}

extension FeedViewController: ViewConfiguration {
    func buildHierarchyView() {
        view.addSubview(tableView)
    }
    
    func activeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1)
        ])
    }
    
    func configureUI() {
        title = "G1 News"
        addSettingsNavigationButton()
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
    }
}

private extension FeedViewController {
    enum Layout {
        static let top: CGFloat = 0
        static let left: CGFloat = 16
        static let right: CGFloat = 16
        static let bottom: CGFloat = 0
    }
}
