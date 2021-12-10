//
// Created by Artur Dąbkowski on 10/12/2021.
//

import Foundation
import UIKit

final class ApplicationCoordinator {
    private let window: UIWindow
    private let environment: EnvironmentProtocol

    private var childCoordinator: AlbumListCoordinator?

    init(window: UIWindow, environment: EnvironmentProtocol) {
        self.window = window
        self.environment = environment
    }

    func start() {
        let urlFactory = RequestFactory(environment: self.environment)
        let artistsReleasesService = ArtistsReleasesService(httpClient: HttpClient(), urlFactory: urlFactory, cacheService: FileCacheService())
        let navigationController = UINavigationController()
        childCoordinator = AlbumListCoordinator(rootViewController: navigationController,
                artistsReleasesService: artistsReleasesService,
                artistsUuid: self.environment.artistUuid,
                artistName: self.environment.artistName)
        childCoordinator?.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
