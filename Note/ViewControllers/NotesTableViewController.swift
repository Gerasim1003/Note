//
//  NotesTableViewController.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/26/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit
import MessageUI

class NotesTableViewController: UITableViewController, AddNoteTableViewControllerDelegate, NotesTableViewCellDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let fileManager = MyFileManager()
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(saveUserData), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        //add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNavButton))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 86.0

        if let user = user {
            self.imageView.image = user.image ?? UIImage(named: "note")
            self.usernameLabel.text = user.username
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.user?.notes.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesTableViewCell else { return UITableViewCell()}
        cell.setup(with: self.user!.notes[indexPath.row])
        cell.delegate = self

        return cell
    }
    
    //editing style
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        user?.notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //MARK: delete note/update user notes /
        //TODO: save user notes when app didEnterBackground in real device
        fileManager.updateUserNotes(user: user!)
    }
    
    //tableview: didSelectt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    @objc func addNavButton() {
        guard let addNoteVC = storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteTableViewController else { return }
        addNoteVC.delegate = self
        let navVC = UINavigationController(rootViewController: addNoteVC)
        present(navVC, animated: true, completion: nil)
    }
    
    //MARK: AddNOteDelegate
    
    func saveNote(note: Note) {
        user!.notes.append(note)
        tableView.reloadData()
        
        //MARK: add note/ savae user notes /
        //TODO: save user notes when app didEnterBackground in real device
        fileManager.updateUserNotes(user: user!)
    }
    
    //NotesTableViewCellDelegate
    func callAlert(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)") else {return}
        let alertVC = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Call", style: .default, handler: { (_) in
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        
        alertVC.addAction(UIAlertAction(title: "SMS", style: .default, handler: { (_) in
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            if MFMessageComposeViewController.canSendText() {
                composeVC.recipients = [phoneNumber]
                composeVC.body = ""
                
                self.present(composeVC, animated: true, completion: nil)
                
            }
            
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MFMailComposeViewControllerDelegate
    func sendMail(mail: String) {
        let alertVC = UIAlertController(title: "Send mail to \(mail)", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients([mail])
                
                self.present(composeVC, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "Cannot Sand Mail", message: nil, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func saveUserData() {
        fileManager.updateUserNotes(user: self.user!)
    }

}
