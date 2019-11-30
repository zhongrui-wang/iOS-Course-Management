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
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message"
        navigationItem.hidesBackButton = true
        messageTableView.dataSource = self
        
        messageTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadMessages()
    }
    
    func loadMessages(){
        
        db.collection("messages").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            if let e = error {
                print("Issue getting data from Firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.messageTableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.messageTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageInputField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: ["sender": messageSender, "body": messageBody, "date": Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue saving the data to firestore, \(e)")
                } else {
                    DispatchQueue.main.async {
                        self.messageInputField.text = ""
                    }
                    print("Successfully saved data.")
                }
            }
        }
    
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
        let message = messages[indexPath.row]
        
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageTableViewCell
        cell.label.text = message.body
        
        //Message from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: "BrandLightPurple")
            cell.label.textColor = UIColor(named: "BrandPurple")
        }
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: "BrandPurple")
            cell.label.textColor = UIColor(named: "BrandLightPurple")
        }

        return cell
    }
}
