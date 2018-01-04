//
//  UIColorExtension.swift
//  ARBottleJump
//
//  Created by 宋 奎熹 on 2018/1/3.
//  Copyright © 2018年 宋 奎熹. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func randomColor() -> UIColor {
        let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let g = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let b = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}
