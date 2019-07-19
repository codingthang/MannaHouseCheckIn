//
//  CustomViews.swift
//  MannaHouseCheckIn
//
//  Created by JubalThang on 7/18/19.
//  Copyright © 2019 Jubal. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UIView {
    
    private var buttonTitles    : [String]!
    private var buttons         : [UIButton]!
    private var selectorView    : UIView!
    
    var mainPage: MainPage?
   
    var textColor: UIColor = UIColor(white: 0, alpha: 0.3)
    var selectorViewColor: UIColor = .black
    var selectorTextColor: UIColor = .white
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        addSubview(stack)
        
        stack.anchor(top: topAnchor, right: trailingAnchor, bottom: bottomAnchor, left: leadingAnchor)
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        
        self.selectorView = UIView(frame: CGRect(x: 0, y: frame.height, width: selectorWidth, height: 4))
        
        selectorView.backgroundColor = UIColor.secondaryColor
        
        addSubview(selectorView)
    }
    
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach{$0.removeFromSuperview()}
        
        for (index,buttonTitle) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.backgroundColor = index%2 == 0 ? UIColor.primaryColor : UIColor.secondaryColor
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    @objc func buttonAction(sender: UIButton){
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                // Connect back to MainPage
                mainPage?.updateIndex(index: buttonIndex)

                btn.setTitleColor(selectorTextColor, for: .normal)
                self.selectorView.backgroundColor = buttonIndex%2 == 0 ? UIColor.secondaryColor : UIColor.primaryColor
            }
        }
    }
    
    // MARK: UpdateAll Views
    private func updateViews() {
        createButtons()
        configSelectorView()
        configStackView()
    }
    
    convenience init(frame: CGRect, buttonTitles: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitles
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateViews()
    }
    
    func setButttonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        updateViews()
    }
}
