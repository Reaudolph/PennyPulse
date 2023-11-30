//
//  ChatViewController.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/30/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class ChatViewController : UIViewController {
    
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    var messages: [Message] = [
       
    ]
    
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        chatTableView.delegate = self
        chatTableView.dataSource = self
        self.navigationItem.hidesBackButton
        
        chatTableView.register(UINib(nibName: "MessageCell", bundle:nil), forCellReuseIdentifier: "ReusableCell")
        loadMessages()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let messageBody = sendTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: [
                "sender" : messageSender,
                "body" : messageBody,
                "date" : Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("ZE BLUECHEWS DEVISHE IS READY TO PAAIH, \(e)")
                } else {
                    print("Succesffully saved")
                }
            }
        }
    }
    
    func loadMessages() {
        
        db.collection("messages").order(by: "date").addSnapshotListener { QuerySnapshot, error in
            self.messages = []

            if let e = error {
                print("issue retriving stuff \(e)")
            }
            else {
                if let snapShot = QuerySnapshot?.documents {
                    for doc in snapShot {
                        let data = doc.data()
                        if let sender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.chatTableView.reloadData()
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    

}


extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.messageLabel?.text = messages[indexPath.row].body
        return cell
    }
    
    
    
}
extension ChatViewController : UITableViewDelegate {
    
    
}
