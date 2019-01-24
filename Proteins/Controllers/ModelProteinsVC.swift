//
//  ModelProteinsViewController.swift
//  Proteins
//
//  Created by Yuliia MAKOVETSKAYA on 12/12/18.
//  Copyright © 2018 Adilyam TILEGENOVA. All rights reserved.
//

import UIKit
import SceneKit

class ModelProteinsVC: UIViewController {

    @IBOutlet weak var proteinsView: SCNView!
    @IBOutlet weak var typeLabel: UILabel!
    
    var proteinsScene: SCNScene!
    var cameraNode: SCNNode!
    var lightNode: SCNNode!
    var scene: SceneProtein?
    
    var elem: [(position: (x: Float, y: Float, z: Float), type: String)]!
    var conect: [[Int]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(elem[0].0)
        initScene()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        proteinsView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: self.proteinsView)
            let hits = self.proteinsView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                let position = tappedNode?.position
                findProtein(position: position!)
            }
        }
    }

    func findProtein(position: SCNVector3) {
        for protein in self.elem {
            if protein.position.x == position.x, protein.position.y == position.y, protein.position.z == position.z {
                self.typeLabel.text = "Type: \(protein.type)"
            }
        }
    }
    
    func initScene () {
        
        scene = SceneProtein(elem: elem, conect: conect)
        
        proteinsScene = scene
        proteinsView.scene = proteinsScene
        proteinsView.allowsCameraControl = true
        proteinsView.autoenablesDefaultLighting = true
        proteinsView.showsStatistics = true
        proteinsView.isPlaying = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.proteinsView.scene?.rootNode.removeAllActions()
    }
    
}
