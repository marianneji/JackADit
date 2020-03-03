//
//  CircularButton.swift
//  JackADit
//
//  Created by Graphic Influence on 28/02/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import UIKit

class CircularButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }

}
