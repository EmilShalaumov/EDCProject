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
    @IBOutlet weak var scrollView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        if isLogged {
            print("Hello, " + username)
            scrollView.documentView!.insertText(username)
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func reloadData() {
        print(AppUser.instance.username + " + 1")
        DispatchQueue.main.async {
            self.helloLabel.stringValue = ("Hello, " + AppUser.instance.username)
        }
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

