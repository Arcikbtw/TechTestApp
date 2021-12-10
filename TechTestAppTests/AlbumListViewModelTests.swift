//
//  AlbumListViewModelTests.swift
//  TechTestAppTests
//
//  Created by Artur Dąbkowski on 10/12/2021.
//

import XCTest
@testable import TechTestApp
import RxSwift
import RxCocoa
import RxTest

final class AlbumListViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var sut: AlbumListViewModel!
    var artistsReleasesServiceMock: ArtistsReleasesServiceMock!
    var artistsUuid: String = "Testid"
    var artistName: String = "TestArtist"

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        artistsReleasesServiceMock = ArtistsReleasesServiceMock()
        artistsReleasesServiceMock.stubbedAlbumsForArtistsResult = .just([])
        sut = AlbumListViewModel(artistService: artistsReleasesServiceMock, artistsUuid: artistsUuid, artistName: artistName)
    }

    func test_reload_shouldInvokeRefresh() throws {
        XCTAssertEqual(artistsReleasesServiceMock.invokedAlbumsForArtistsCount, 0)
        sut.input.reload.accept(())
        XCTAssertEqual(artistsReleasesServiceMock.invokedAlbumsForArtistsCount, 1)
        sut.input.reload.accept(())
        XCTAssertEqual(artistsReleasesServiceMock.invokedAlbumsForArtistsCount, 2)
    }

    func test_reload_shouldInvokeLoading() throws {
        let observer = scheduler.createObserver(Bool.self)
        sut.output.loading.asObservable().bind(to: observer).disposed(by: disposeBag)

        sut.input.reload.accept(())

        XCTAssertEqual(observer.events.count, 2)
        XCTAssertEqual(observer.events[0].value.element, true)
        XCTAssertEqual(observer.events[1].value.element, false)
    }

    func test_reload_shouldInvokeError_whenEmptyArray() throws {
        let observer = scheduler.createObserver(AlbumListViewModel.Output.ErrorMessage.self)
        sut.output.error.asObservable().bind(to: observer).disposed(by: disposeBag)

        sut.input.reload.accept(())

        XCTAssertEqual(observer.events.count, 1)
    }

    func test_reload_shouldInvokeError_whenServiceError() throws {
        artistsReleasesServiceMock.stubbedAlbumsForArtistsResult = .error("Error")
        sut = AlbumListViewModel(artistService: artistsReleasesServiceMock, artistsUuid: artistsUuid, artistName: artistName)
        let observer = scheduler.createObserver(AlbumListViewModel.Output.ErrorMessage.self)
        sut.output.error.asObservable().bind(to: observer).disposed(by: disposeBag)

        sut.input.reload.accept(())

        XCTAssertEqual(observer.events.count, 1)
    }
}
