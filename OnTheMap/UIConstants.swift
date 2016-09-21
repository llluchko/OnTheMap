//
//  UIConstants.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 3/23/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import UIKit

// MARK: - Constants

struct UIConstants {
    

    // MARK: UI
    
    struct Colors {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        static let darkerBlue = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        static let lighterBlue = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    
    // MARK: Setup
    
    struct Setup {
        static let titleLabelFontSize: CGFloat = 17.0
        static let borderedButtonHeight: CGFloat = 44.0
        static let borderedButtonCornerRadius: CGFloat = 4.0
        static let phoneBorderedButtonExtraPadding: CGFloat = 14.0
    }
    
    // MARK: Selectors
    
    struct Selectors {
        static let KeyboardWillShow: Selector = Selector("keyboardWillShow:")
        static let KeyboardWillHide: Selector = Selector("keyboardWillHide:")
        static let KeyboardDidShow: Selector = Selector("keyboardDidShow:")
        static let KeyboardDidHide: Selector = Selector("keyboardDidHide:")
    }
}
