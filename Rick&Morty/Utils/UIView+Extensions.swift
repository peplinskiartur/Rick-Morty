//
//  UIView+Extensions.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 10/07/2023.
//

import UIKit

extension UIView {
    func withoutAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    static func withoutAutoLayout() -> Self {
        Self().withoutAutoLayout()
    }
}
