//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Network
import RxSwift

extension NWPathMonitor {
    var rx_connection: Observable<Bool> {
        Observable.create { [self] observer in
            self.pathUpdateHandler = { path in
                observer.onNext(path.status == .satisfied)
            }
            let queue = DispatchQueue(label: "com.techtestapp.pathmonitor")
            self.start(queue: queue)
            return Disposables.create {
                self.cancel()
            }
        }
    }
}
