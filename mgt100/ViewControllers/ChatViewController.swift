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

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageInputField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message"
        navigationItem.hidesBackButton = true
        messageTableView.dataSource = self
        messageTableView.delegate = self
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
                                //let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageInputField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").document(messageBody).setData([
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
                ]) { (error) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageTableViewCell
        cell.label.text = message.body
        
        //Message from current user

        cell.messageBubble.backgroundColor = UIColor.white
        cell.label.textColor = UIColor.black
        
        cell.label.font = UIFont(name: "Poppins-Medium", size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedQuestionViewController = mainStoryBoard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        
        
        detailedQuestionViewController.questionName = messages[indexPath.row].body
        self.navigationController?.pushViewController(detailedQuestionViewController, animated: true)
        
    }

}
