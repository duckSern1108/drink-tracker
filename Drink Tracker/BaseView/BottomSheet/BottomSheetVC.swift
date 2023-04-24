//
//  BottomSheetVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 24/04/2023.
//

import UIKit
import RxSwift
import RxGesture
import RxKeyboard


class BottomSheetVC: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightCT: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomCT: NSLayoutConstraint!
    
    static func newVC(contentVC: UIViewController, fixedTop: Double) -> BottomSheetVC {
        let vc = BottomSheetVC()
        vc.transitioningDelegate = vc
        vc.contentHeight = UIScreen.main.bounds.height - fixedTop
        vc.contentVC = contentVC
        return vc
    }
    
    static func newVC(contentVC: UIViewController, contentHeight: Double) -> BottomSheetVC {
        let vc = BottomSheetVC()
        vc.transitioningDelegate = vc
        vc.contentHeight = contentHeight
        vc.contentVC = contentVC
        return vc
    }
    
    enum AnimationType {
        case presented
        case dismiss
    }
    
    var transitionType: AnimationType? = nil
    var contentHeight: Double = 0
    var contentVC: UIViewController!
    var backgroundAlpha = 0.4
    var needListenToKeyboard = true
    var keyboardHeight: Double = 0
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightCT.constant = contentHeight
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addChildVC(contentVC, toSubview: containerView)
        backgroundView.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.keyboardHeight > 0 {
                    self.view.endEditing(true)
                } else {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance
            .visibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self,
                      self.needListenToKeyboard
                else { return }
                self.keyboardHeight = height
                UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
                    self.contentViewBottomCT.constant = height
                    self.view.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
    }
}

extension BottomSheetVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            self.transitionType = .presented
            return self
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            self.transitionType = .dismiss
            return self
        }
        return nil
    }
}

extension BottomSheetVC: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let transitionType = self.transitionType else { return 0 }
        if transitionType == .presented {
            return 0.44
        } else {
            return 0.2
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let transitionType = self.transitionType else {
            transitionContext.completeTransition(false)
            return
        }
        let duration = self.transitionDuration(using: transitionContext)
        if transitionType == .presented {
            UIView.performWithoutAnimation {
                self.view.backgroundColor = .clear
                self.containerView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.contentHeight)
            }
            
            guard let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: duration, delay: 0.0, animations: {
                self.view.backgroundColor = UIColor(hex: "000000").withAlphaComponent(self.backgroundAlpha)
                self.containerView.transform = CGAffineTransform.identity
            },completion: { isCompleted in
                self.transitionType = nil
                transitionContext.completeTransition(isCompleted)
            })
        } else {
            let transaltionY = self.view.bounds.height - contentHeight
            UIView.animate(withDuration: duration, delay: 0.0, animations: {
                self.view.backgroundColor = .clear
                self.containerView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.contentHeight)
            },completion: { isCompleted in
                self.transitionType = nil
                transitionContext.completeTransition(isCompleted)
            })
        }
    }
}


