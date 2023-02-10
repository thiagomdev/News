import Foundation

protocol ViewModelProtocol: AnyObject {
    func showDetailView()
    func setupOnErrorReceived()
}

final class ViewModel {
    var model: [Item] = []
    var page: Int = 1
    
    weak var delegate: ViewModelProtocol?
    private let service: FeedNewsServiceProtocol
    private let hasMorePage = false
    var showServiceError: ((Error?) -> Void)?
    var reloadData: (() -> Void)?

    init(service: FeedNewsServiceProtocol = FeedNewsService(), model: [Item] = []) {
        self.service = service
        self.model = model
    }
    
    func fetchData(page: Int) {
        service.request(page: page) { [weak self] result in
            switch result {
            case let .success(model):
                self?.model.append(contentsOf: model.items)
                self?.reloadData?()
            case let .failure(error):
                self?.showServiceError?(error)
            }
        }
    }
    
    func showDetailView() {
        delegate?.showDetailView()
    }
}
