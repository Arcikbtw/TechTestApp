//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation
import RxSwift

extension CacheService {
    func readData(with name: String) -> Observable<Data> {
        Observable.create { [weak self] observer in
            if let self = self {
                do {
                    observer.onNext(try self.readData(name: name))
                } catch {
                    observer.onError("Data Read issue")
                }
            } else {
                observer.onError("Data Read issue")
            }
            observer.onCompleted()

            return Disposables.create()
        }
    }
}
