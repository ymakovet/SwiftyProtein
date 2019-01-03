//
//  ApiManager.swift
//  Proteins
//
//  Created by Adilyam TILEGENOVA on 12/21/18.
//  Copyright © 2018 Adilyam TILEGENOVA. All rights reserved.
//

import Foundation


class ApiManager: NSObject {
    
    private var elem: [(Position: (x: Float, y: Float, z: Float), Type: String)] = []
    private var conect: [[Int]] = [[]]
    
//    override init() {
//        super.init()
//    }
    
    func getProteinFullInfo(name: String, completion: @escaping (Bool, [(Position: (x: Float, y: Float, z: Float), Type: String)], [[Int]]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: "https://file.rcsb.org/ligands/view/\(name)_model.pdb") {
                do {
                    let contents = try String(contentsOf: url)
                    self.parse(contents: contents)
                    completion(true, self.elem, self.conect)
                    
                } catch {
                    print(error.localizedDescription)
                    completion(false, self.elem, self.conect)
                }
                
                
            }
            else {
                print("url error")
                completion(false, self.elem, self.conect)
            }
        }
        
    }
    
    private func parse(contents: String) {
        let connect1 = contents.components(separatedBy: "\n")
        
        let connect2 = connect1.filter{$0.contains("CONECT")}
        let connect3 = connect2.map{$0.components(separatedBy: " ")}
        let connect4 = connect3.map{$0.filter{$0 != ""}}
        let connect5 = connect4.map{$0.filter{$0 != "CONECT"}}
        let connect6 = connect5.map{$0.map{Int($0)!}}
        
        conect = connect6
        
        let atom1 = connect1.filter{$0.contains("ATOM")}
        let atom2 = atom1.map{$0.components(separatedBy: " ")}
        
        
        let atom3 = atom2.map{$0.filter{$0.contains(".")}}
        let atom4 = atom3.map{$0.map{Float($0)!}}
        
        for i in 0..<atom4.count {
            let tuple = (x: atom4[i][0], y: atom4[i][1], z: atom4[i][2])
            elem.append((tuple, atom2[i].last ?? "C"))
        }
    }
}
