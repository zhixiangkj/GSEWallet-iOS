//
//  PayPopView.swift
//  ios+cordovaDemo
//
//  Created by 付金亮 on 2018/12/6.
//  Copyright © 2018 付金亮. All rights reserved.
//

import UIKit

class Popup {
    static let shared = Popup()
    lazy var bgView = UIView.init(frame: UIScreen.main.bounds)
    var deliverView: UIView?
    var content: UIView?
    var delegate: PopupDelegate?
    init() {
        bgView.tag = 100
        bgView.backgroundColor = UIColor.black
        self.bgView.alpha = 0
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(maskTapped))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        bgView.addGestureRecognizer(gesture)
    }
    func show(deliverV: UIView, superView: UIView?) {
        deliverView = deliverV
        let height = deliverV.bounds.size.height
        let width = deliverV.bounds.size.width
        deliverV.frame = CGRect.init(x: (SCREEN_WIDTH - width) / 2, y:  SCREEN_HEIGHT - height, width: width, height: height)
        deliverV.transform = CGAffineTransform.init(translationX: 0, y: SCREEN_HEIGHT)
        if let superView = superView {
            superView.addSubview(bgView)
            superView.addSubview(deliverV)
        } else {
            KEY_WINDOW?.addSubview(bgView)
            KEY_WINDOW?.addSubview(deliverV)
        }
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0.2
            deliverV.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    @objc private func maskTapped() {
        hide()
        if (delegate != nil) {
            delegate?.popupMaskTapped()
        }
    }
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0
            self.deliverView!.transform = CGAffineTransform.init(translationX: 0, y: SCREEN_HEIGHT)
        }) { (finisheh) in
            self.content?.removeFromSuperview()
            self.bgView.removeFromSuperview()
            self.deliverView!.removeFromSuperview()
        }
    }
}

protocol PopupDelegate: class {
    func popupMaskTapped()
}
