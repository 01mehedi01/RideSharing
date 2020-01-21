//
//  CustomButton.swift
//  Cloude
//
//  Created by Mehedi Hasan on 19/1/20.
//  Copyright © 2020 Mehedi Hasan. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        
        backgroundColor     = Colors.tropicBlue
       // backgroundColor       = UIColor(white: Colors.tropicBlue, alpha: 0.7)
        titleLabel?.font    = UIFont(name: Fonts.avenirNextCondensedDemiBold, size: 22)
        layer.cornerRadius  = frame.size.height/2
        
        setTitleColor(.black, for: .normal)
    }
}
