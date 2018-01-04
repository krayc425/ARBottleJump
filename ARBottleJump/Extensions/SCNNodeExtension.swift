//
//  SCNNodeExtension.swift
//  ARBottleJump
//
//  Created by 宋 奎熹 on 2018/1/3.
//  Copyright © 2018年 宋 奎熹. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    func isNotContainedXZ(in boxNode: SCNNode) -> Bool {
        let box = boxNode.geometry as! SCNBox
        let width = Float(box.width)
        if fabs(position.x - boxNode.position.x) > width / 2.0 {
            return true
        }
        if fabs(position.z - boxNode.position.z) > width / 2.0 {
            return true
        }
        return false
    }
    
}
