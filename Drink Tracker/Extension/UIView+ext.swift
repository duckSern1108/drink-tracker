//
//  UIView+ext.swift
//  SSTCloud
//
//  Created by Le Trung on 18/02/2023.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func removeAllSubViews() {
        for eachSub in self.subviews {
            eachSub.removeFromSuperview()
        }
    }
}
