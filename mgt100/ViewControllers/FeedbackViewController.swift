//
//  FeedbackViewController.swift
//  mgt100
//
//  Created by RUI WANG on 11/29/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import Firebase

class FeedbackViewController: UIViewController {

    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBAction func clickButton(_ sender: UIButton) {
        let answer = sender.currentTitle
        appendAnswers(answer: answer!)
        print(answers.answerset)
        if questionNum < questions.count - 1 {
            questionNum += 1
            updateUI()
        }
        else{
            question.text = "Finish!"
            question.textAlignment = .center
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            finished = true
            defaults.set(finished, forKey: "finishedOrNot")
        }
    }
    
    struct APIResults: Codable {
        let Questions: [Question]
    }
    struct Question: Codable {
        let a: String
        let b: String
        let c: String
        let q: String
    }
    let defaults = UserDefaults.standard
    var quizBrain : APIResults?
    var questions: [Question] = []
    var questionNum = 0
    var finished = false
    func grabFirebaseData(){
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                self.quizBrain = try JSONDecoder().decode(APIResults.self, from: jsonData)
                //print(self.quizBrain)
            } catch let error {
                print(error)
            }
            
            for i in self.quizBrain!.Questions{
                self.questions.append(i)
            }
            
            self.updateUI()
        })
    }
    
    
    
    
    struct Answers {
        let question: String
        let answer: String
        
        init(q:String, a:String) {
            question = q
            answer = a
        }
    }
    
    struct Answerset {
        var answerset = [Answers]()
    }
    
    
    var answers = Answerset()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        UIView.animate(withDuration: 0) {
            statusBar?.backgroundColor = UIColor(red: 57/255.0, green: 90/255.0, blue: 255/255.0, alpha: 1)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        UIView.animate(withDuration: 0) {
            statusBar?.backgroundColor = UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 34)
        
        if defaults.bool(forKey: "finishedOrNot") == true {
            question.text = "You have finished!"
            question.textAlignment = .center
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
        }
        else{
            grabFirebaseData()
        }
        // Do any additional setup after loading the view.
       
    }
    
    func appendAnswers(answer:String) {
        let singleAnswer = Answers(q: questions[questionNum].q, a: answer)
        answers.answerset.append(singleAnswer)
    }

    func updateUI() {
        question.text = questions[questionNum].q
        progress.progress = Float(questionNum)/Float(questions.count - 1)
        button1.setTitle(questions[questionNum].a, for: .normal)
        button2.setTitle(questions[questionNum].b, for: .normal)
        button3.setTitle(questions[questionNum].c, for: .normal)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
