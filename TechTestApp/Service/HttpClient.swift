//
//  HttpClient.swift
//  TechTestApp
//
//  Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation
import RxSwift

protocol HttpClientProtocol: AnyObject {
    func makeRequest(_ request: URLRequest) -> Observable<Data>
}

final class HttpClient: HttpClientProtocol {
    private let urlSession: URLSession = URLSession.shared
    private let disposeBag: DisposeBag = DisposeBag()

    func makeRequest(_ request: URLRequest) -> Observable<Data> {
        Observable.create { observer in
            let task = self.urlSession.dataTask(with: request) { data, _, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(data ?? Data())
                }

                observer.onCompleted()
            }

            task.resume()

            return Disposables.create()
        }
    }
}
