//
//  ApplicationCoordinator.swift
//  TechTestApp
//
//  Created by Artur Dąbkowski on 10/12/2021.
//

import Foundation
import UIKit

final class AlbumListCoordinator {
    private let rootViewController: UINavigationController
    private let artistsReleasesService: ArtistsReleasesServiceProtocol
    private let artistsUuid: String
    private let artistName: String

    init(rootViewController: UINavigationController, artistsReleasesService: ArtistsReleasesServiceProtocol, artistsUuid: String, artistName: String) {
        self.rootViewController = rootViewController
        self.artistsReleasesService = artistsReleasesService
        self.artistsUuid = artistsUuid
        self.artistName = artistName
    }

    func start() {
        let viewModel = AlbumListViewModel(artistService: artistsReleasesService, artistsUuid: artistsUuid, artistName: artistName)
        let viewController = AlbumListViewController(viewModel: viewModel, delegate: self)
        rootViewController.pushViewController(viewController, animated: false)
    }
}

extension AlbumListCoordinator: AlbumListViewControllerDelegate {
    func showAlert(title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.addAction(.init(title: NSLocalizedString("global.ok", comment: ""), style: .cancel))
        rootViewController.present(vc, animated: true)
    }
}
