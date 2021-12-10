//
//  Observable+Toggle.swift
//  TechTestApp
//
//  Created by Artur Dąbkowski on 10/12/2021.
//

import RxSwift

public extension Observable where Element == Bool {
    func toggle() -> Observable<Bool> {
        return self.map { value -> Bool in return !value }
    }
}
