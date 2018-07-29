//
//  HelperClasses.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//


import UIKit

class CustomInsetLabel: UILabel {
    private var topInset = CGFloat(0)
    private var bottomInset = CGFloat(0)
    private var leftInset = CGFloat(0)
    private var rightInset = CGFloat(0)
    
    func setupInsets(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        topInset = top
        bottomInset = bottom
        leftInset = left
        rightInset = right
        drawText(in: frame)
    }
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
