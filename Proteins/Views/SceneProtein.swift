//
//  SceneProtein.swift
//  Proteins
//
//  Created by Yuliia MAKOVETSKAYA on 12/21/18.
//  Copyright © 2018 Adilyam TILEGENOVA. All rights reserved.
//

import UIKit
import SceneKit

class SceneProtein: SCNScene {
    
    var elem: [(position: (x: Float, y: Float, z: Float), type: String)] = []
    var conect: [[Int]] = [[]]
    var type: String = ""
    
    init(elem: [(position: (x: Float, y: Float, z: Float), type: String)], conect: [[Int]])
    {
        super.init()
        self.elem = elem
        self.conect = conect
        addCamera()
        drawAtom()
        drawConnection()
    }
    
    func addCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        var xMin: Float = elem[0].position.x
        var xMax: Float = elem[0].position.x
        var yMin: Float = elem[0].position.y
        var yMax: Float = elem[0].position.y
        var zMax: Float = elem[0].position.z
        
        for el in elem {
            
            if xMin > el.position.x {
               xMin = el.position.x
            }
            if xMax < el.position.x {
               xMax = el.position.x
            }
            
            if yMin > el.position.y {
                yMin = el.position.y
            }
            if yMax < el.position.y {
                yMax = el.position.y
            }
            
            if zMax < el.position.z {
                zMax = el.position.z
            }
        }
        
        cameraNode.position = SCNVector3(x: (xMin + xMax) / 2, y: (yMin + yMax) / 2, z: zMax + 40)
        
        self.rootNode.addChildNode(cameraNode)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func drawConnection()
    {
        let nbr: Int = elem.count
        var i: Int = 0
        
        for item in conect {
            if (i < nbr)
            {
                let origin: SCNVector3 = SCNVector3(x: elem[i].position.x, y: elem[i].position.y, z: elem[i].position.z)
                for nb in item
                {
                    if (nb <= nbr && i + 1 < nb)
                    {
                        let dest: SCNVector3 = SCNVector3(x: elem[nb - 1].position.x, y: elem[nb - 1].position.y, z: elem[nb - 1].position.z)
                        self.rootNode.addChildNode(LineNode(node: rootNode, vector1: origin, vector2: dest))
                    }
                }
            }
            i = i + 1
        }
    }
    
    func drawAtom()
    {
        for atom in elem {
            let sphere = SCNSphere(radius: 0.4)
            sphere.firstMaterial?.diffuse.contents = self.CPKcoloring(type: atom.type)
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3(x: atom.position.x, y: atom.position.y, z: atom.position.z)
            self.rootNode.addChildNode(sphereNode)
        }
    }
    
    func CPKcoloring(type: String) -> UIColor
    {
        switch type {
        case "H":
            return UIColor.white
        case "C":
            return UIColor.black
        case "N":
            return UIColor.blue
        case "O" :
            return UIColor.red
        case "F", "Cl":
            return UIColor.green
        case "Br":
            return UIColor(red: 0.54, green: 0.17, blue: 0.08, alpha: 1.0)
        case "I":
            return UIColor(red: 0.37, green: 0.06, blue: 0.71, alpha: 1.0)
        case "He", "Ne", "Ar", "Xe", "Kr":
            return UIColor(red: 0.46, green: 0.98, blue: 0.99, alpha: 1.0)
        case "P":
            return UIColor(red: 0.95, green: 0.62, blue: 0.22, alpha: 1.0)
        case "S":
            return UIColor(red: 0.98, green: 0.90, blue: 0.33, alpha: 1.0)
        case "B":
            return UIColor(red: 0.95, green: 0.68, blue: 0.50, alpha: 1.0)
        case "Li", "Na", "K", "Rb", "Cs":
            return UIColor(red: 0.42, green: 0.07, blue: 0.96, alpha: 1.0)
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            return UIColor(red: 0.2, green: 0.46, blue: 0.12, alpha: 1.0)
        case "Ti":
            return UIColor.gray
        case "Fe":
            return UIColor(red: 0.81, green: 0.49, blue: 0.18, alpha: 1.0)
        default:
            return UIColor(red: 0.81, green: 0.49, blue: 0.97, alpha: 1.0)
        }
    }
}
