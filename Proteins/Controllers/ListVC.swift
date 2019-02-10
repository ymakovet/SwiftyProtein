//
//  ListVC.swift
//  Proteins
//
//  Created by Ruslan NAUMENKO on 2/10/19.
//  Copyright © 2019 UNIT Factory. All rights reserved.
//

import UIKit

//typealias CompletionHandler = (_ success:Bool) -> Void

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let actInd = UIActivityIndicatorView()
    
    private let apiManager = ApiManager()
    
    private var filteredArray = [String]()
    private var currentArray = [String]()
    
    private var names = [String]() {
        didSet {
            if names.count > 0 {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parse()
        hideKeyboardWhenTappedAround()
    }
    
    private func parse() {
        if let url = URL(string: "https://projects.intra.42.fr/uploads/document/document/312/ligands.txt") {
            do {
                let contents = try String(contentsOf: url)
                names = contents.components(separatedBy: "\n")
                currentArray = names
            } catch {
                showAlertController(error.localizedDescription)
            }
        }
    }
    
    private func showActivityIndicatory() {
        actInd.frame = CGRect(x: 0.0, y: 0.0, width:40.0, height: 40.0);
        actInd.center = view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = .gray
        view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    private func removeActivityIndicator(){
        actInd.stopAnimating()
        actInd.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSceneKit" {
            let data = sender as! ([(position: (x: Float, y: Float, z: Float), type: String)], [[Int]], String)
            let destination = segue.destination as! ModelProteinsVC
            
            destination.elem = data.0
            destination.conect = data.1
            destination.navigationItem.title = data.2
            self.removeActivityIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = currentArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showActivityIndicatory()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        apiManager.getProteinFullInfo(name: self.currentArray[indexPath.row]) { [unowned self] (success, elem, conect) in
            if success {
                DispatchQueue.main.async {
                    let title = tableView.cellForRow(at: indexPath)?.textLabel?.text
                    self.performSegue(withIdentifier: "showSceneKit", sender: (elem, conect, title))
                }
            } else {
                self.showAlertController("Failed loading from site")
            }
        }
    }
}


extension ListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentArray = names
            tableView.reloadData()
            return
        }
        currentArray = names.filter{$0.lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
    }
}

