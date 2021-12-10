//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation

protocol RequestFactoryProtocol: AnyObject {
    func artistsRequest(for uuid: String) -> URLRequest?
    func releasesRequestForArtist(with uuid: String) -> URLRequest?
}

final class RequestFactory: RequestFactoryProtocol {
    private enum Endpoints: String {
        case artists
        case releases
    }

    private enum Headers: String {
        case authorization = "Authorization"
    }

    private let environment: EnvironmentProtocol

    init(environment: EnvironmentProtocol) {
        self.environment = environment
    }

    func artistsRequest(for uuid: String) -> URLRequest? {
        guard let url = URL(string: environment.baseUrl + Endpoints.artists.rawValue + "/" + uuid ) else { return nil }
        return request(for: url)
    }

    func releasesRequestForArtist(with uuid: String) -> URLRequest? {
        guard let url = URL(string: environment.baseUrl + Endpoints.artists.rawValue + "/" + uuid + "/" + Endpoints.releases.rawValue) else { return nil }
        return request(for: url)
    }

    private func request(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(environment.token, forHTTPHeaderField: Headers.authorization.rawValue)
        return request
    }
}
