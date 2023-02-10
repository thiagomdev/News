import XCTest
@testable import G1News

final class FeedNewsServiceTests: XCTestCase {
    // It'll be implemented later.
}

final class FeedNewsServiceSpy: FeedNewsServiceProtocol {
    var result: (Result<FeedResponse, Error>) = .success(.init(items: .init()))
    
    func request(page: Int, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        completion(result)
    }
}
