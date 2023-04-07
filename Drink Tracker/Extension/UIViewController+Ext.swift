import UIKit
import SnapKit


extension UIViewController {
    func addChildVC (_ child: UIViewController, toSubview subview: UIView? = nil) {
        guard subview == view || (subview?.isDescendant(of: view) != false) else { return }
        addChild(child)
        (subview ?? view).addSubview(child.view)
        child.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        child.didMove(toParent: self)
    }
}

