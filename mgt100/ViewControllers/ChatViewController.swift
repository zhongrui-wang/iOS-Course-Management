//
//  ChatViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/26/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageInputField: UITextField!
    
    
    var messages: [Message] = [
        Message(sender: "12@live.com", body: "Hey"),
        Message(sender: "aa@live.com", body: "Hello"),
        Message(sender: "12@live.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message"
        navigationItem.hidesBackButton = true
        messageTableView.dataSource = self
        
        messageTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
            
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageTableViewCell
        cell.label.text = messages[indexPath.row].body
        
        
        
        return cell
    }
}
