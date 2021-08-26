//
//  Style4Button.swift
//  Calculator
//
//  Created by Ewen on 2021/8/25.
//

import UIKit

class Style4Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor    = Colors.numberBackgroundWhite
        tintColor          = Colors.deleteTitleGray
        
        setTitleColor(Colors.deleteTitleGray, for: .normal)
        layer.cornerRadius = 16
        layer.borderWidth   = 2
        layer.borderColor   = Colors.borderGray.cgColor
    }
}
