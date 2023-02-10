import Foundation

protocol Request {
    var baseUrl: String { get }
    var endpoint: String { get }
    var parameters: [String : String]? { get }
    var header: [String : String]? { get }
    var body: Data? { get }
    var method: HttpMethod { get }
}

protocol RequestTasking {
    var request: Request { get }
    func resume()
    func cancel()
}

extension Request {
    var baseUrl: String { "http://falkor-cda.bastian.globo.com" }

    var url: String {
        switch self.method {
        case .get:
            
            var component = URLComponents()
            let params = parameters ?? [:]
            var queryItems: [URLQueryItem] = []
            for (key, value) in params {
                queryItems.append(URLQueryItem(
                    name: key,
                    value: value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)))
            }
            
            component.queryItems = queryItems
            return baseUrl + endpoint + component.path
            
        default:
            return baseUrl + endpoint
        }
    }
}

final class RequestTask<T: Decodable>: RequestTasking {
    let request: Request
    private let completion: ((Result<T, Error>) -> Void)?
    private var dataTask: URLSessionDataTask?
    
    init(request: Request, completion: ((Result<T, Error>) -> Void)?) {
        self.request = request
        self.completion = completion
    }
    
    func resume() {
        guard let url = URL(string: request.url) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.request.header
        request.httpMethod = self.request.method.rawValue
        request.httpBody = self.request.body
        
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let httpsResponse = response as? HTTPURLResponse else { return }
            if (200..<300).contains(httpsResponse.statusCode), let data = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    self?.completion?(.success(decoded))
                } catch let err {
                    self?.completion?(.failure(err))
                }
                
            } else if let error = error {
                self?.completion?(.failure(error))
            } else {
                self?.completion?(.failure(NSError(domain: "interno", code: -999)))
            }
        })
        dataTask?.resume()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
}
