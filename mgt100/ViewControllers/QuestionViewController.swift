//
//  QuestionViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/30/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class QuestionViewController: UIViewController {

    
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    
    @IBOutlet weak var questionTextField: UITextField!
    
    
    let db = Firestore.firestore()
    
    var questions: [Questions] = []
    
    var questionName: String?
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        questionTableView.dataSource = self
        questionLabel.text = questionName
        questionLabel.font = UIFont(name: "Poppins-Regular", size: 17)
        
        questionTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadQuestions()
    }
    
    func loadQuestions(){
        
        db.collection("messages").document(questionName!).collection("questions").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
            
            self.questions = []
            if let e = error {
                print("Issue getting data from collection, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let newQuestion = Questions(sender: messageSender, body: messageBody)
                            self.questions.append(newQuestion)
                            
                            
                            DispatchQueue.main.async {
                                self.questionTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendQuestion(_ sender: UIButton) {
        if(questionTextField.text!.count > 5){
            if let questionBody = questionTextField.text, let questionSender = Auth.auth().currentUser?.email {
                db.collection("messages").document(questionName!).collection("questions").document(questionBody).setData([
                    "sender": questionSender,
                    "body": questionBody,
                    "date": Date().timeIntervalSince1970
                    ]) { (error) in
                        if let e = error {
                            print("There was an issue saving the data to firestore, \(e)")
                        } else {
                            DispatchQueue.main.async {
                                self.questionTextField.text = ""
                            }
                            print("Successfully saved data.")
                        }
                    }
                }
        }
        else {
            let refreshAlert = UIAlertController(title: "Invalid input", message: "Minimum value is 5 characters", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
}

extension QuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let question = questions[indexPath.row]
        let cell = questionTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! QuestionTableViewCell
        
        cell.label.text = question.body
        cell.author.text = "Sent by \(question.sender)"
        
        
        return cell
    }
    
    
}
