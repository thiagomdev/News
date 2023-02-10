import Foundation

protocol FeedNewsServiceProtocol {
    func request(page: Int, completion: @escaping(Result<FeedResponse, Error>) -> Void)
}

enum FeedRequest: Request {
    case `default`(page: Int)
    
    var endpoint: String {
        switch self {
        case let .default(page):
            return "/feeds/b904b430-123a-4f93-8cf4-5365adf97892/posts/page/\(page)"
        }
    }
    
    var parameters: [String : String]? { nil }
    var header: [String : String]? { nil }
    var body: Data? { nil }
    
    var method: HttpMethod {
        .get
    }
}

final class FeedNewsService: FeedNewsServiceProtocol {
    private let network: NetworkingProtocol
    private var task: RequestTasking?
    
    init(network: NetworkingProtocol = Networking()) {
        self.network = network
    }
    
    func request(page: Int, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        task = network.make(request: FeedRequest.default(page: page), responseType: FeedResponse.self, completion: { result in
            switch result {
            case let .success(success):
                completion(.success(success))
            case let .failure(err):
                completion(.failure(err))
            }
        })
        task?.resume()
    }
}
