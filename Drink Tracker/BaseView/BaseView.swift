//
//  BaseView.swift
//  SSTCloud
//
//  Created by Le Trung on 09/02/2023.
//

import UIKit
import SnapKit

protocol BaseViewProtocol: AnyObject {
    func configure()
}

extension UIView {
    @discardableResult
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: .main)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        else { return nil }
        addSubview(nibView)
        nibView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sendSubviewToBack(nibView)
        return nibView
    }
}

class BaseView: UIView, BaseViewProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        self.configure()
    }
    
    func configure() {
        // Perform any common setup and configuration for the view here
    }
}
