//
// Created by Artur Dąbkowski on 09/12/2021.
//

import UIKit

extension UIView {
    func addSubviewAndFill(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([leadingAnchor.constraint(equalTo: subview.leadingAnchor),
         trailingAnchor.constraint(equalTo: subview.trailingAnchor),
         topAnchor.constraint(equalTo: subview.topAnchor),
         bottomAnchor.constraint(equalTo: subview.bottomAnchor)])
    }

    func addSubviewAndCenter(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([centerYAnchor.constraint(equalTo: subview.centerYAnchor),
                                     centerXAnchor.constraint(equalTo: subview.centerXAnchor)])
    }
}
