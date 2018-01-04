//
//  BubbleTextNode.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import SceneKit

class BubbleTextNode: SCNNode {

    private let bubbleDepth : Float = 0.015 // the 'depth' of 3D text
    
    init(text: String, at position: SCNVector3) {
        super.init()
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // Lights
        let omniBackLight = SCNLight()
        omniBackLight.type = .omni
        omniBackLight.color = UIColor.white
        let omniBackLightNode = SCNNode()
        omniBackLightNode.light = omniBackLight
        omniBackLightNode.position = SCNVector3(position.x - 2, 0, position.z - 2)
        
        let omniFrontLight = SCNLight()
        omniFrontLight.type = .omni
        omniFrontLight.color = UIColor.white
        let omniFrontLightNode = SCNNode()
        omniFrontLightNode.light = omniFrontLight
        omniFrontLightNode.position = SCNVector3(position.x + 2, 0, position.z + 2)
        
        self.addChildNode(omniBackLightNode)
        self.addChildNode(omniFrontLightNode)
        
        // Text
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth / 5.0))
        bubble.font = UIFont(name: "HelveticaNeue", size: 0.18)
        bubble.alignmentMode = kCAAlignmentCenter
        bubble.firstMaterial?.diffuse.contents = UIColor.white
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = false
        bubble.flatness = 0.01 // setting this too low can cause crashes.
        bubble.chamferRadius = 0.05
        
        // Bubble
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Center Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation((maxBound.x - minBound.x) / 2, minBound.y, bubbleDepth / 2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        let backgroundBox = SCNBox(width: CGFloat((maxBound.x - minBound.x) / 4),
                                   height: 0.05,
                                   length: 0.02,
                                   chamferRadius: 0.01)
        backgroundBox.firstMaterial?.diffuse.contents = UIColor.lightGray
        backgroundBox.firstMaterial?.specular.contents = UIColor(white: 0.5, alpha: 0.80)
        backgroundBox.firstMaterial?.isDoubleSided = false
        
        // Box Node
        let backgroundNode = SCNNode(geometry: backgroundBox)
        bubbleNode.position = SCNVector3(0, -0.01, bubbleDepth)
        backgroundNode.addChildNode(bubbleNode)
        backgroundNode.name = "backgroundNode"
        
        self.addChildNode(backgroundNode)
        
        self.name = text

        self.constraints = [billboardConstraint]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
