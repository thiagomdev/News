import Foundation

protocol NetworkingProtocol {
    func make<T: Decodable>(request: Request, responseType: T.Type ,completion: @escaping(Result<T, Error>) -> Void) -> RequestTasking
}

final class Networking: NetworkingProtocol {
    func make<T>(request: Request, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> RequestTasking where T : Decodable {
        RequestTask<T>(request: request, completion: completion)
    }
}
