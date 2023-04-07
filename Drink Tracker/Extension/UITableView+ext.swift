//
//  UIScrollView+ext.swift
//  SSTCloud
//
//  Created by Le Trung on 18/02/2023.
//

import UIKit

extension UITableView {
    func addBackground(_ text: String) {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.text = text
        backgroundView = label
    }
    
    func removeBackground() {
        backgroundView = nil
    }
}

extension UITableView {
    /// Register Table Cell
    /// - Parameters:
    ///   - aClass: Cell class
    ///   - bundle: Bundle
    func register<T: UITableViewCell>(_ aClass: T.Type, bundle: Bundle? = .main) {
        let name = String(describing: aClass)
        if bundle?.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }
    
    /// Dequeue Table  Cell
    /// - Parameter aClass: Cell class
    /// - Returns: Cell instance
    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
    
    func registerNibs(from classes: [AnyClass]) {
        classes.forEach { (anClass) in
            let className = String.fromClass(anClass.self)
            self.register(UINib(nibName: className, bundle: Bundle(for: anClass)), forCellReuseIdentifier: className)
        }
    }
    
    func reloadData(duration: Double = 0.1, completion:@escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }) { _ in completion() }
    }
}

