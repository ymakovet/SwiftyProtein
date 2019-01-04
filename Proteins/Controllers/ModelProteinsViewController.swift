//
//  ModelProteinsViewController.swift
//  Proteins
//
//  Created by Yuliia MAKOVETSKAYA on 12/12/18.
//  Copyright © 2018 Adilyam TILEGENOVA. All rights reserved.
//

import UIKit
import SceneKit

class ModelProteinsViewController: UIViewController {

    @IBOutlet weak var proteinsView: SCNView!
    var proteinsScene: SCNScene!
    var cameraNode: SCNNode!
    var lightNode: SCNNode!
    var scene: SceneProtein?
    
    var elem: [(position: (x: Float, y: Float, z: Float), type: String)]!
    var conect: [[Int]]!
//    var elem = [(Position: (x: Float, y: Float, z: Float), Type: String)]()
//    var conect = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCamera()
        initView()
        initScene()
    }

    
    func initView() {
        proteinsView.allowsCameraControl = true
        proteinsView.autoenablesDefaultLighting = true
    }
    
    func initScene () {
        
        scene = SceneProtein(elem: elem, conect: conect)
        
        proteinsScene = scene
        proteinsScene.rootNode.addChildNode(lightNode)
        proteinsScene.rootNode.addChildNode(cameraNode)
        proteinsView.scene = proteinsScene
        proteinsView.showsStatistics = true
        proteinsView.isPlaying = true
    }
    
    func initCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
    }

    
}
