import XCTest
@testable import G1News

final class FeedViewModelTests: XCTestCase {
    typealias Sut = ViewModel
    
    func test_ShowDetailView_ShouldAppearSettingsView() {
        let sut = Sut()
        let viewModelSpy = ViewModelSpy()
        sut.delegate = viewModelSpy
        
        sut.showDetailView()
        
        XCTAssertEqual(viewModelSpy.messages, [.showDetailView])
    }
    
    func test_FetchData_WhenNeedToGetSomePage_ShouldReturnPage() {
        let mock = MockFeedItemService()
        let model: [Item] = []
        let sut = Sut(service: mock, model: model)
        let page = 1
        
        sut.fetchData(page: page)
        
        XCTAssertEqual(mock.page, page)
        XCTAssertEqual(sut.model, model)
    }
}

final class MockFeedItemService: FeedNewsServiceProtocol {
    var page: Int?
    var fetchData: String?
    var feed: FeedResponse?

    func request(page: Int, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        self.page = page
        guard let feed = feed else { return }
        completion(.success(feed))
    }
}

final class ViewModelSpy: ViewModelProtocol {
    private(set) var serviceError: Error?
    
    enum Messages: Equatable {
        case showDetailView
        case setupOnErrorReceived
    }
    
    private(set) var messages: [Messages] = []
    
    func showDetailView() {
        messages.append(.showDetailView)
    }
    
    func setupOnErrorReceived() {
        messages.append(.setupOnErrorReceived)
    }
}
