//
//  SCNVector3Extension.swift
//  ARBottleJump
//
//  Created by 宋 奎熹 on 2018/1/1.
//  Copyright © 2018年 宋 奎熹. All rights reserved.
//

import SceneKit

extension SCNVector3 {

    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }

}
