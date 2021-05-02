import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
    func requestWithToken(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {
    
    private let apiKey: String = "58C4eIKJUBOaPdu3BiADbi2KFBstyb9ofVLekpFS59NBfnBFWwyD7B84HzId"
//        private let apiKey: String = "demo"

    private let token: String = "c1r91biad3iatqdnjfs0"

    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        var allParams = params
        allParams["apikey"] = apiKey
        let url = self.url(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        print(url)
        task.resume()
    }
    
    func requestWithToken(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        var allParams = params
        allParams["token"] = token
        let url = self.urlWithToken(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        print(url)
        task.resume()
    }

    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = "/api/v1" + EndPoint.init(rawValue: path)!.rawValue
        components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func urlWithToken(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = ApiFinnhub.scheme
        components.host = ApiFinnhub.host
        components.path = "/api/v1" + EndPoint.init(rawValue: path)!.rawValue
        components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
