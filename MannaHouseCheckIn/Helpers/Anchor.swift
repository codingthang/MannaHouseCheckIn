//
//  Anchor.swift
//  CheckIn
//
//  Created by JubalThang on 7/15/19.
//  Copyright © 2019 Jubal. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, size: CGSize = CGSize(width: 0, height: 0), padding: UIEdgeInsets =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)){
        translatesAutoresizingMaskIntoConstraints = false
        if let t = top {
            topAnchor.constraint(equalTo: t, constant: padding.top).isActive = true
        }
        if let r = right {
            trailingAnchor.constraint(equalTo: r, constant: -padding.right).isActive = true
        }
        if let b = bottom {
            bottomAnchor.constraint(equalTo: b, constant: -padding.bottom).isActive = true
        }
        if let l = left {
            leadingAnchor.constraint(equalTo: l, constant: padding.left).isActive = true
        }
        if let x = centerX {
            centerXAnchor.constraint(equalTo: x).isActive = true
        }
        if let y = centerY {
            centerYAnchor.constraint(equalTo: y).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    func anchorSize(to view:UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    func fillSuperView() {
        anchor(top: superview?.topAnchor, right: superview?.trailingAnchor, bottom: superview?.bottomAnchor, left: superview?.leadingAnchor, centerX: nil, centerY: nil, size: .zero, padding: .zero)
    }
    
    func setupShadow(offset: CGSize, opacity: Float, radius: CGFloat? = 3.0, color: UIColor? = UIColor.black) {
        if let r = radius {
            layer.shadowRadius = r
        }
        if let c = color {
            layer.shadowColor = c.cgColor
        }
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
    func vStack(views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.spacing = 10
        stack.axis = .vertical
        return stack
    }
    func hStack(views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }
}

extension UIColor {
    func customRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return  UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
