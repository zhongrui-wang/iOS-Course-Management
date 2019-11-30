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
    
    
//    struct Question {
//        let questions: String
//        let button1: String
//        let button2: String
//        let button3: String
//
//        init(q:String, a:String, b:String, c: String) {
//            questions = q
//            button1 = a
//            button2 = b
//            button3 = c
//        }
//    }
    
//    struct Quizbrain {
//        let quiz = [Question(q: "Thee instructor presented content in an organized manner.", a: "Agree", b: "Neutral", c: "Disagree"),
//                    Question(q: "The instructor explained the lecture clearly.", a: "Agree", b: "Neutral", c: "Disagree"),
//                    Question(q: "The instructor was helpful when I had difficulties or questions.", a: "Agree", b: "Neutral", c: "Disagree"),
//                    Question(q: "The instructor provided clear constructive feedback.", a: "Agree", b: "Neutral", c: "Disagree"),
//                    Question(q: "The instructor encouraged student questions and participation.", a: "Agree", b: "Neutral", c: "Disagree"),
//                    Question(q: "The lecture developed my abilities and skills for the subject.", a: "Agree", b: "Neutral", c: "Disagree"),
//                    Question(q: "How much do you learn from this lecture?", a: "100%", b: "80%", c: "50%"),
//                    Question(q: "How many former lectures did you review?", a: "100%", b: "80%", c: "50%"),
//                    Question(q: "On average, how many hours per week have you spent on this course?", a: "10", b: "6", c: "2")
//        ]
//
//        var questionNum = 0
//    }
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
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
