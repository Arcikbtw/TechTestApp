//
// Created by Artur Dąbkowski on 10/12/2021.
//

import Foundation
@testable import TechTestApp
import RxSwift

final class ArtistsReleasesServiceMock: ArtistsReleasesServiceProtocol {

    var invokedAlbumsForArtists = false
    var invokedAlbumsForArtistsCount = 0
    var invokedAlbumsForArtistsParameters: (uuid: String, Void)?
    var invokedAlbumsForArtistsParametersList = [(uuid: String, Void)]()
    var stubbedAlbumsForArtistsResult: Observable<[ReleasesDto.Release]>!

    func albumsForArtists(with uuid: String) -> Observable<[ReleasesDto.Release]> {
        invokedAlbumsForArtists = true
        invokedAlbumsForArtistsCount += 1
        invokedAlbumsForArtistsParameters = (uuid, ())
        invokedAlbumsForArtistsParametersList.append((uuid, ()))
        return stubbedAlbumsForArtistsResult
    }
}
