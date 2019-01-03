//
//  LineNode.swift
//  Proteins
//
//  Created by Yuliia MAKOVETSKAYA on 12/24/18.
//  Copyright © 2018 Adilyam TILEGENOVA. All rights reserved.
//

import UIKit
import SceneKit

class LineNode: SCNNode {
    
    let radius: CGFloat = 0.1
    let radSegmentCount: Int = 48
    let nodeV2 = SCNNode()
    init(node: SCNNode, vector1: SCNVector3, vector2: SCNVector3)
    {
        super.init()
        let height = vector1.distance(receiver: vector2)
        position = vector1
        
        nodeV2.position = vector2
        
        node.addChildNode(nodeV2)
        
        let axisZ = SCNNode()
        axisZ.eulerAngles.x = Float(CGFloat(Double.pi / 2))
        
        let cylinder = SCNCylinder(radius: radius, height: CGFloat(height))
        cylinder.radialSegmentCount = radSegmentCount
        cylinder.firstMaterial?.diffuse.contents = UIColor.white
        
        
        let lineNode = SCNNode(geometry: cylinder)
        lineNode.position.y = -height/2
        axisZ.addChildNode(lineNode)
        
        addChildNode(axisZ)
        
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


private extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let x = receiver.x - self.x
        let y = receiver.y - self.y
        let z = receiver.z - self.z
        let distance = Float(sqrt(x * x + y * y + z * z))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
