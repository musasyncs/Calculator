//
//  Style3Button.swift
//  Calculator
//
//  Created by Ewen on 2021/8/25.
//

import UIKit

class Style3Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor    = Colors.equalBackgroundBlue
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 16
        layer.borderWidth   = 2
        layer.borderColor   = Colors.borderGray.cgColor
    }
}
