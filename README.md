# NetFlow

## Installation 

Add Package using Swift Package Manager from Xcode with URL: https://github.com/ivarunpatel/NetFlow

### Setup 

Create struct and confirm to `NetworkConfigurable` which allow you to setup baseURL, headers and query parameters which is used by all requests configured using instance of this struct. 

```
public struct ApiNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    public let headers: [String: String]
    public let queryParameters: [String: String]
    
    public init(baseURL: URL, headers: [String: String], queryParameters: [String: String]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
```

Create class which confirms to `HTTPClient` protocol which make use of URLSesstion and make request. You can also use default implemented class `URLSessionHTTPClient` which is added in package itself. 

```
public final class URLSessionHTTPClient: HTTPClient {
    private let networkConfigurable: NetworkConfigurable
    private let session: URLSession
    
    public init(networkConfigurable: NetworkConfigurable, session: URLSession = .shared) {
        self.networkConfigurable = networkConfigurable
        self.session = session
    }
    
    public func execute(request: Requestable) async throws -> (Data, URLResponse) {
        let urlRequest = try request.urlRequest(with: networkConfigurable)
        return try await session.data(for: urlRequest)
    }
}
```

Create Endpoint by confirming to `Requestable` protocol which allow you to setup path, method and request specific query parameters. 

```
struct FeedEndpoint: Requestable {
    var path: String = "/v1/gifs/trending"
    var isFullPath: Bool = false
    var method: HTTPMethodType = .get
    var queryParameters: [String: Any] = [:]
}
```

Request Example

```
 let networkConfigurable = ApiNetworkConfig(baseURL: URL(string: appConfiguration.baseURL)!, headers: [:], queryParameters: ["api_key": appConfiguration.apiKey, "rating": "g"])
 let httpClient = URLSessionHTTPClient(networkConfigurable: networkConfigurable)
 
func load(limit: Int, offset: Int) async throws -> FeedPage {
        let queryParameters = ["limit": limit, "offset": offset]
        let feedEndpoint = FeedEndpoint(queryParameters: queryParameters)
        let (data, response) = try await httpClient.execute(request: feedEndpoint)
        guard (response as? HTTPURLResponse)?.statusCode == OK_200 else {
            throw HTTPClientError.connectivity
        }
        return try FeedResponseMapper.map(data: data)
    }
```    

Please give Star ⭐️ if you like this simple networking library. More updates are coming. 

