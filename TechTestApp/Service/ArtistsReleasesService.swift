//
//  ArtistsService.swift
//  TechTestApp
//
//  Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation
import RxSwift
import RxRelay
import Network

extension String: Error {}

protocol ArtistsReleasesServiceProtocol {
    func albumsForArtists(with uuid: String) -> Observable<[ReleasesDto.Release]>
}

final class ArtistsReleasesService: ArtistsReleasesServiceProtocol {
    private let httpClient: HttpClientProtocol
    private let urlFactory: RequestFactoryProtocol
    private let pathMonitor: NWPathMonitor
    private let cacheService: CacheService
    private let disposeBag: DisposeBag = DisposeBag()

    private let isConnected: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    init(httpClient: HttpClientProtocol, urlFactory: RequestFactoryProtocol, cacheService: CacheService) {
        self.httpClient = httpClient
        self.urlFactory = urlFactory
        self.pathMonitor = NWPathMonitor()
        self.cacheService = cacheService

        pathMonitor.rx_connection.bind(to: isConnected).disposed(by: disposeBag)
    }

    // MARK: - ArtistsReleasesServiceProtocol

    func albumsForArtists(with uuid: String) -> Observable<[ReleasesDto.Release]> {
        guard let request = urlFactory.releasesRequestForArtist(with: uuid) else {
            return Observable<[ReleasesDto.Release]>.error("Invalid artists")
        }

        let result: Observable<[ReleasesDto.Release]>

        if isConnected.value {
            result = httpClient.makeRequest(request).withUnretained(self).do { owner, data in
                try? owner.cacheService.saveData(name: uuid, data: data)
            }.map { $1 }.decode(type: ReleasesDto.self, decoder: JSONDecoder()).map { $0.releases }
        } else {
            // load
            result = cacheService.readData(with: uuid).decode(type: ReleasesDto.self, decoder: JSONDecoder()).map { $0.releases }
        }

        return result
    }
}
