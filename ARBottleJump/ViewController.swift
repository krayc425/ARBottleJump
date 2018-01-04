//
//  ViewController.swift
//  ARBottleJump
//
//  Created by 宋 奎熹 on 2018/1/1.
//  Copyright © 2018年 宋 奎熹. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private var currentAnchor: ARAnchor?
    
    private var boxNodes: [SCNNode] = []
    private lazy var bottleNode: BottleNode = {
        return BottleNode()
    }()
    
    private var maskTouch: Bool = false
    private var nextDirection: NextDirection = .left
    
    private var touchTimePair: (begin: TimeInterval, end: TimeInterval) = (0, 0)
    private let distanceCalculateClosure: (TimeInterval) -> CGFloat = {
        return CGFloat($0) / 4.0
    }
    private let kMoveDuration: TimeInterval = 0.25
    private let kBoxWidth: CGFloat = 0.2
    private let kJumpHeight: CGFloat = 0.2
    
    private var score: UInt = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.scoreLabel.text = "\((self?.score)!)"
            }
        }
    }
    private let scoreLabel = UILabel(frame: CGRect(x: 50, y: 50, width: UIScreen.main.bounds.width - 100, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true

        sceneView.session.run(configuration)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        scoreLabel.font = UIFont(name: "HelveticaNeue", size: 30.0)
        scoreLabel.textColor = .white
        sceneView.addSubview(scoreLabel)
        
        restartGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func restartGame() {
        touchTimePair = (0, 0)
        score = 0
        boxNodes.forEach {
            $0.removeFromParentNode()
        }
        bottleNode.removeFromParentNode()
        boxNodes.removeAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentAnchor != nil else {
            return
        }
        if boxNodes.isEmpty  {
            func addConeNode() {
                bottleNode.position = SCNVector3(boxNodes.last!.position.x,
                                                 boxNodes.last!.position.y + Float(kBoxWidth) * 0.75,
                                                 boxNodes.last!.position.z)
                sceneView.scene.rootNode.addChildNode(bottleNode)
            }
            
            func anyVectorFrom(location: CGPoint) -> (SCNVector3)? {
                let results = sceneView.hitTest(location, types: .featurePoint)
                guard !results.isEmpty else {
                    return nil
                }
                return SCNVector3.positionFromTransform(results[0].worldTransform)
            }
            
            let location = touches.first?.location(in: sceneView)
            if let position = anyVectorFrom(location: location!) {
                generateBox(at: position)
                addConeNode()
                generateBox(at: boxNodes.last?.position)
            }
        } else {
            if !maskTouch {
                maskTouch = true
            }
            
            touchTimePair.begin = (event?.timestamp)!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentAnchor != nil && !boxNodes.isEmpty else {
            return
        }
        
        if maskTouch {
            maskTouch = false
            
            touchTimePair.end = (event?.timestamp)!
            
            let distance = distanceCalculateClosure(touchTimePair.end - touchTimePair.begin)
            var actions = [SCNAction()]
            if nextDirection == .left {
                let moveAction1 = SCNAction.moveBy(x: distance, y: kJumpHeight, z: 0, duration: kMoveDuration)
                let moveAction2 = SCNAction.moveBy(x: distance, y: -kJumpHeight, z: 0, duration: kMoveDuration)
                actions = [SCNAction.rotateBy(x: 0, y: 0, z: -.pi * 2, duration: kMoveDuration * 2),
                           SCNAction.sequence([moveAction1, moveAction2])]
            } else {
                let moveAction1 = SCNAction.moveBy(x: 0, y: kJumpHeight, z: distance, duration: kMoveDuration)
                let moveAction2 = SCNAction.moveBy(x: 0, y: -kJumpHeight, z: distance, duration: kMoveDuration)
                actions = [SCNAction.rotateBy(x: .pi * 2, y: 0, z: 0, duration: kMoveDuration * 2),
                           SCNAction.sequence([moveAction1, moveAction2])]
            }
            
            bottleNode.recover()
            bottleNode.runAction(SCNAction.group(actions), completionHandler: { [weak self] in
                let boxNode = (self?.boxNodes.last!)!
                if (self?.bottleNode.isContainedXZ(in: boxNode))! {
                    ScoreHelper.shared.setHighestScore(Int((self?.score)!))
                    
                    self?.alert(message: "You Lose!\n\nScore: \((self?.score)!)\n\nHighest: \(ScoreHelper.shared.getHighestScore())")
                    
                    self?.restartGame()
                } else {
                    self?.score += 1
                    
                    var scorePosition: SCNVector3 = SCNVector3()
                    scorePosition = SCNVector3(x: 0, y: 0.2, z: 0)
                    let scoreNode = BubbleTextNode(text: "+1", at: scorePosition)
                    scoreNode.position = scorePosition
                    self?.bottleNode.addChildNode(scoreNode)
                    
                    let action = SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 0.75)
                    scoreNode.runAction(action, completionHandler: {
                        scoreNode.removeFromParentNode()
                    })
                    
                    self?.generateBox(at: self?.boxNodes.last!.position)
                }
            })
        }
    }
    
    private func generateBox(at position: SCNVector3?) {
        let box = SCNBox(width: kBoxWidth, height: kBoxWidth / 2.0, length: kBoxWidth, chamferRadius: 0.0)
        let node = SCNNode(geometry: box)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.randomColor()
        box.materials = [material]
        
        if let realPosition = position {
            if boxNodes.isEmpty {
                node.position = realPosition
            } else {
                nextDirection = NextDirection(rawValue: Int(arc4random() % 2))!
                let deltaDistance = Double(arc4random() % 25 + 25) / 100.0  // range: 0.25 ~ 0.5
                if nextDirection == .left {
                    node.position = SCNVector3(realPosition.x + Float(deltaDistance), realPosition.y, realPosition.z)
                } else {
                    node.position = SCNVector3(realPosition.x, realPosition.y, realPosition.z + Float(deltaDistance))
                }
            }
        }
        
        sceneView.scene.rootNode.addChildNode(node)
        boxNodes.append(node)
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if currentAnchor == nil {
            currentAnchor = anchor
            
            let light = SCNLight()
            light.type = .directional
            light.color = UIColor(white: 1.0, alpha: 1.0)
            light.shadowColor = UIColor(white: 0.0, alpha: 0.8).cgColor
            let lightNode = SCNNode()
            lightNode.eulerAngles = SCNVector3Make(-.pi / 3, .pi / 4, 0)
            lightNode.light = light
            sceneView.scene.rootNode.addChildNode(lightNode)
            
            let ambientLight = SCNLight()
            ambientLight.type = .ambient
            ambientLight.color = UIColor(white: 0.8, alpha: 1.0)
            let ambientNode = SCNNode()
            ambientNode.light = ambientLight
            sceneView.scene.rootNode.addChildNode(ambientNode)
            
            alert(message: "Touch anywhere to begin")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if maskTouch {
            bottleNode.scaleHeight()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
}
