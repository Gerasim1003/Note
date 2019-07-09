//
//  NotesTableViewController.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/26/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit
import MessageUI

class NotesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNoteTableViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let fileManager = MyFileManager()
    
    var user: User?
    var indexPathOfEditedRow: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self

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
    
    //MARK: SegmentControl
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
        case 1:
            tableView.isHidden = true
        default:
            break
        }
        
        collectionView.isHidden = !tableView.isHidden
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.user?.notes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesTableViewCell else { return UITableViewCell()}
        cell.setup(with: self.user!.notes[indexPath.row])
        cell.delegate = self

        return cell
    }
    
    //MARK: editing style
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let VC = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteTableViewController else { return }
            VC.editMode = true
            VC.note = self.user?.notes[indexPath.row]
            VC.delegate = self
            self.indexPathOfEditedRow = indexPath
            let navigationController = UINavigationController(rootViewController: VC)
            self.present(navigationController, animated: true, completion: nil)
        }
        let deleteRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.user?.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        editRowAction.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        
        return [deleteRowAction, editRowAction]
    }
    
    //tableview: didSelectt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCell(at: indexPath)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailVC.note = user?.notes[indexPath.row]
        let navigationVC = UINavigationController(rootViewController: detailVC)
        self.present(navigationVC, animated: true, completion: nil)
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
        collectionView.reloadData()
        //MARK: add note
    }

    func updateNote(note: Note) {
        if let indexPathOfEditedRow = indexPathOfEditedRow {
            user?.notes[indexPathOfEditedRow.row] = note
            tableView.reloadRows(at: [indexPathOfEditedRow], with: .none)
//            collectionView.reloadItems(at: [indexPathOfEditedRow])
        }
        
        //MARK: update note
    }
    
    @objc func saveUserData() {
        fileManager.updateUserNotes(user: self.user!)
    }
    
}

//MARK: extension NotesTableViewController: NotesTableViewCellDelegate
extension NotesTableViewController: NotesTableViewCellDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
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
}

//MARK: CollectionView
extension NotesTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.notes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollecionViewCell", for: indexPath) as? NotesCollecionViewCell else { return UICollectionViewCell()}
        cell.setup(with: self.user!.notes[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(at: indexPath)
    }
    
    // MARK: - Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width * 2) / 3
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollecionViewCell", for: indexPath) as? NotesCollecionViewCell else {
            return CGSize(width: width, height: width)
        }
        
        var imageHeight = cell.collectioViewCellImageHeightConstraint.constant
        
        if user?.notes[indexPath.row].image == nil {
            imageHeight = 0
        }
        
        let height = imageHeight
            + cell.noteTitleLabel.frame.height
            + cell.descriptionLabel.frame.height
            + 15
        
        return CGSize(width: width, height: height)
    }
    
}

