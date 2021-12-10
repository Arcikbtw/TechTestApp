//
// Created by Artur Dąbkowski on 09/12/2021.
//

import UIKit

@propertyWrapper
struct ContainerView<T> where T: UIView {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }

    init() {
        self.wrappedValue = T()
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
