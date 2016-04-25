//
//  BorderedButton.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 3/23/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import UIKit

// MARK: - BorderedButton: Button

class BorderedButton: UIButton {

    // MARK: Properties
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        themeBorderedButton()
    }
    
    private func themeBorderedButton() {
        layer.masksToBounds = true
        layer.cornerRadius = UIConstants.Setup.borderedButtonCornerRadius
        highlightedBackingColor = UIConstants.Colors.darkerBlue
        backingColor = UIConstants.Colors.lighterBlue
        backgroundColor = UIConstants.Colors.lighterBlue
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        titleLabel?.font = UIFont.systemFontOfSize(UIConstants.Setup.titleLabelFontSize)
    }
    
    // MARK: Setters
    
    private func setBackingColor(newBackingColor: UIColor) {
        if let _ = backingColor {
            backingColor = newBackingColor
            backgroundColor = newBackingColor
        }
    }
    
    private func setHighlightedBackingColor(newHighlightedBackingColor: UIColor) {
        highlightedBackingColor = newHighlightedBackingColor
        backingColor = highlightedBackingColor
    }
    
    // MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    // MARK: Layout
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = UIConstants.Setup.phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSizeZero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = UIConstants.Setup.borderedButtonHeight
        return sizeThatFits
    }
}