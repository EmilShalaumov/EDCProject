//
//  ViewController.swift
//  EDCClient (mac)
//
//  Created by Эмиль Шалаумов on 20/01/2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Cocoa

var username: String = "empty"
var isLogged: Bool = false

class ViewController: NSViewController {
    
    @IBOutlet weak var helloLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var idx: Int = 2
    var FileArray: [FileCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        if isLogged {
            print("Hello, " + username)
        }

    }
    
    @objc func reloadData() {
        print(AppUser.instance.username + " + 1")
        getFilesList()
        idx = 3
        DispatchQueue.main.async {
            self.helloLabel.stringValue = ("Hello, " + AppUser.instance.username)
            self.tableView.reloadData()
        }
    }
    
    func getFilesList() {
        FileArray = []
        guard let url = URL(string: "http://localhost:8080/getfiles") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                //experiment
                let decoder = JSONDecoder()
                do {
                    self.FileArray = try decoder.decode([FileCell].self, from: data)
                    print(self.FileArray)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    override func viewDidAppear() {
        if !isLogged {
            self.performSegue(withIdentifier: "showLoginView", sender: self)
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showLoginView", sender: self)
    }
    
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return FileArray.count
    }
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        var cellText: String = ""
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = "FileNameCell"
            cellText = FileArray[row].filename
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = "OwnerCell"
            cellText = FileArray[row].owner
        } else {
            cellIdentifier = "StatusCell"
            cellText = FileArray[row].checkflag
        }
        
        print(cellIdentifier)
        print(cellText)

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = cellText
            return cell
        }
        return nil
    }
}

struct FileCell: Codable {
    let filename: String
    let owner: String
    let checkflag: String
}
