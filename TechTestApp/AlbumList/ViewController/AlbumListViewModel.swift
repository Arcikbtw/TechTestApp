//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation
import RxCocoa
import RxSwift

final class AlbumListViewModel {
    var input: AlbumListViewModel.Input
    var output: AlbumListViewModel.Output

    struct Input {
        let reload: PublishRelay<Void>
    }

    struct Output {
        struct ErrorMessage {
            let title: String
            let message: String
        }
        let refresh: Driver<[AlbumTableViewCellModel]>
        let title: Driver<String>
        let loading: Driver<Bool>
        let error: Driver<ErrorMessage>
    }

    private let artistService: ArtistsReleasesServiceProtocol
    private let artistsUuid: String
    private let artistsName: String

    private let refreshRelay: PublishRelay<[AlbumTableViewCellModel]> = PublishRelay<[AlbumTableViewCellModel]>()
    private let errorRelay: PublishRelay<Output.ErrorMessage> = PublishRelay<Output.ErrorMessage>()
    private let loadingRelay: PublishRelay<Bool> = PublishRelay<Bool>()
    private let disposeBag: DisposeBag = DisposeBag()

    init(artistService: ArtistsReleasesServiceProtocol, artistsUuid: String, artistName: String) {
        self.artistsUuid = artistsUuid
        self.artistService = artistService
        self.artistsName = artistName

        self.input = Input(reload: PublishRelay<Void>())
        self.output = Output(refresh: self.refreshRelay.asDriver(onErrorJustReturn: [] as [AlbumTableViewCellModel] ),
                title: .just(artistName).asDriver(),
                loading: self.loadingRelay.asDriver(onErrorJustReturn: false),
                error: self.errorRelay.asDriver(onErrorJustReturn: .init(title: "", message: "")))

        setupBindings()
    }

    private func setupBindings() {
        let reload = self.input.reload.share()

        reload.map { true }.bind(to: loadingRelay).disposed(by: disposeBag)
        let reloadCall = reload.withUnretained(self).flatMapLatest { owner, _ -> Observable<Event<[ReleasesDto.Release]>> in
                    owner.artistService.albumsForArtists(with: owner.artistsUuid).materialize()
                }
                .share()

        reloadCall.errors()
                .map { _ in [] as [AlbumTableViewCellModel] }
                .bind(to: refreshRelay)
                .disposed(by: disposeBag)

        reloadCall.elements()
                .map { $0.map { AlbumTableViewCellModel(imageUrl: $0.thumb, title: $0.title, year: String($0.year) ) } }
                .bind(to: refreshRelay)
                .disposed(by: disposeBag)

        refreshRelay.filter { $0.count == 0 }
                .map { _ in
                    Output.ErrorMessage(title: NSLocalizedString("global.error", comment: ""), message: NSLocalizedString("albumList.error", comment: ""))
                }
                .bind(to: errorRelay).disposed(by: disposeBag)
        refreshRelay.map { _ in false }.bind(to: loadingRelay).disposed(by: disposeBag)
    }
}
