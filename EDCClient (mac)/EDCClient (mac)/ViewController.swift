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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isLogged {
            print("Hello, " + username)
        }

        // Do any additional setup after loading the view.
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

