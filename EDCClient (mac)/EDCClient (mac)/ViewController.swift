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

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showLoginView", sender: self)
    }
    
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return idx
    }
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = "FileNameCell"
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = "OwnerCell"
        } else {
            cellIdentifier = "StatusCell"
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = "Hello"
            return cell
        }
        return nil
    }
}
