//
// Created by Artur Dąbkowski on 10/12/2021.
//

import RxSwift

extension ObservableType where Element: EventConvertible {
    func elements() -> Observable<Element.Element> {
        return filter { $0.event.element != nil }.map { $0.event.element! }
    }

    func errors() -> Observable<Swift.Error> {
        return filter { $0.event.error != nil }.map { $0.event.error! }
    }

    func complete() -> Observable<Void> {
        return filter { $0.event.isCompleted }.mapToVoid()
    }

    func stopped() -> Observable<Void> {
        return filter { $0.event.isStopEvent }.mapToVoid()
    }

    func mapToVoid() -> Observable<Void> {
        return self.map { _ -> Void in return Void() }
    }
}
