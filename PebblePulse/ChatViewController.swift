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
        Message(sender: "Rishi", body: "Yoo"),
        Message(sender: "Lauren", body: "WSG"),
        Message(sender: "EJ", body: "Not much")
    ]
    
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        chatTableView.delegate = self
        chatTableView.dataSource = self
        self.navigationItem.hidesBackButton
        
        chatTableView.register(UINib(nibName: "MessageCell", bundle:nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let messageBody = sendTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: [
                "sender" : messageSender,
                "body" : messageBody
            ]) { error in
                if let e = error {
                    print("ZE BLUECHEWS DEVISHE IS READY TO PAAIH, \(e)")
                } else {
                    print("Succesffully saved")
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
