//
//  UICollectionView+ext.swift
//  SSTCloud
//
//  Created by Le Trung on 18/02/2023.
//

import UIKit

extension UICollectionView {
    /// Register Collection Cell
    /// - Parameters:
    ///   - aClass: Cell class
    ///   - bundle: Bundle
    func register<T: UICollectionViewCell>(_ aClass: T.Type, bundle: Bundle? = .main) {
        let name = String(describing: aClass)
        if bundle?.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }
    
    /// Dequeue Collection  Cell
    /// - Parameters:
    ///   - aClass: Cell class
    ///   - indexPath: Cell's index path
    /// - Returns: Cell instance
    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, _ indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
}

