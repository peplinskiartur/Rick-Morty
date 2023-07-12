//
//  Reusable.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension Reusable {
    static var reusableIdentifier: String { String(describing: self) }
}

extension UITableViewCell: Reusable { }

extension UITableView {
    func register<T: UITableViewCell & Reusable>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: T.reusableIdentifier)
    }

    func dequeue<T: UITableViewCell & Reusable>(_ type: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: T.reusableIdentifier) as? T
    }
}

extension UICollectionViewCell: Reusable { }

extension UICollectionView {
    func regiser<T: UICollectionViewCell & Reusable>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    func dequeue<T: UICollectionViewCell & Reusable>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T
    }
}
