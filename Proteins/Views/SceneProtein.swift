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
        print(elem)
        print(conect)
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
    
//    func drawConnection()
//    {
//        let nbr: Int = elem.count
//        var i: Int = 0
//        var count: Int = 0
//        for item in conect {
//            if (i < nbr)//-
//            {
//                let origin: SCNVector3 = SCNVector3(x: elem[i].position.x, y: elem[i].position.y, z: elem[i].position.z)
//                var j: Int = 1
//                while (j < item.count)
//                {
//                    let nb: Int = item[j]
//                    if (nb <= nbr && i + 1 < nb)//+
//                    {
//                        let dest: SCNVector3 = SCNVector3(x: elem[nb - 1].position.x, y: elem[nb - 1].position.y, z: elem[nb - 1].position.z)
//                        self.rootNode.addChildNode(LineNode(node: rootNode, vector1: origin, vector2: dest))
//                        count = count + 1
//                    }
//                    j = j + 1
//                }
//            }
//            i = i + 1
//        }
//    }
    
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
            return (UIColor.white)
        case "C":
            return (UIColor.black)
        case "N":
            return (UIColor.blue)
        case "F" :
            return (UIColor.red)
        case "Cl":
            return (UIColor.green)
        case "Br":
            return (UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0))
        case "I":
            return (UIColor(red: 0.58, green: 0.0, blue: 0.82, alpha: 1.0))
        case "He", "Ne", "Ar", "Xe", "Kr":
            return(UIColor.cyan)
        case "P":
            return(UIColor.orange)
        case "S":
            return(UIColor.yellow)
        case "B":
            return (UIColor(red: 0.98, green: 0.5, blue: 0.44, alpha: 1.0))
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            return (UIColor(red: 0.54, green: 0.16, blue: 0.88, alpha: 1.0))
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            return (UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0))
        case "Ti":
            return (UIColor.gray)
        case "Fe":
            return (UIColor(red: 1.0, green: 0.55, blue: 0.0, alpha: 1.0))
        default:
            return (UIColor(red: 1.0, green: 0.75, blue: 0.79, alpha: 1.0))
        }
    }
}
