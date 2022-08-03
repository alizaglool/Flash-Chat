//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var massage: [Massage] = [
        Massage(sender: "ali@ali.com", body: "Hey!"),
        Massage(sender: "ali@ali.com", body: "Hello!"),
        Massage(sender: "ali@ali.com", body: "What's Up!")
      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessage()

    }
    
    func loadMessage(){
        
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { querySnapshot, error in
            self.massage = []
            if let e = error {
                print("the Data reade error \(e)")
            }else{
                if let querySnapshotDocument = querySnapshot?.documents {
                    for document in querySnapshotDocument {
                        let data = document.data()
                        if let messageSender = data[K.FStore.senderField] as? String , let messageBody = data[K.FStore.bodyField] as? String {
                            let messageDoc = Massage(sender: messageSender, body: messageBody)
                            self.massage.append(messageDoc)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexpath = IndexPath(row: self.massage.count - 1 , section: 0)
                                self.tableView.scrollToRow(at: indexpath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageSender = Auth.auth().currentUser?.email , let messageBody = messageTextfield.text {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970] ) { (error) in
                if let e = error {
                    print("The Data Noy Save Becouse\(e)")
                }else{
                    print("Successfuly")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
    
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }
    

}

extension ChatViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messages = massage[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MassageCell
        cell.LabelMassage.text = messages.body
        
        // message from current User
        if messages.sender == Auth.auth().currentUser?.email {
            cell.liftImageMessage.isHidden = true
            cell.rightImageMassage.isHidden = false
            cell.ViewMassage.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.LabelMassage.textColor = UIColor(named: K.BrandColors.purple)
        }// message from anther account
        else{
            cell.liftImageMessage.isHidden = false
            cell.rightImageMassage.isHidden = true
            cell.ViewMassage.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.LabelMassage.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        
        
        return cell
    }
    
    
}
