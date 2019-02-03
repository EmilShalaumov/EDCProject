//
//  LoginController.swift
//  EDCClient (mac)
//
//  Created by Эмиль Шалаумов on 20/01/2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Cocoa

class LoginController: NSViewController {

    @IBOutlet weak var usernameTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(nil)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        repeat {
            guard let url = URL(string: "http://localhost:8080/login") else {break}
            let parameters = ["username": usernameTextField.stringValue]
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { break }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    let decoder = JSONDecoder()
                    let user = try! decoder.decode(User.self, from: data)
                    username = user.username
                    isLogged = true
                    print(username)
                    AppUser.instance.username = username
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
                } catch {
                    print(error)
                }
                
            }.resume()
            break
        } while(true)
        
        self.dismiss(nil)
    }
}

struct User: Codable {
    var username: String
}
