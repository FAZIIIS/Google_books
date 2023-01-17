//
//  UILabaelWithInsets.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 03/01/23.
//

import Foundation
import UIKit

class UILabelWithInsets: UILabel {
    
    public var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay() // вызывает drawText после установки отступов
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
