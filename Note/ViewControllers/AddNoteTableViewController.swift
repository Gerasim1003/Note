//
//  AddNoteTableViewController.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/26/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

protocol AddNoteTableViewControllerDelegate: class {
    func saveNote(note: Note)
    func updateNote(note: Note)
}

class AddNoteTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var titleLable: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var mailLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var editMode: Bool = false
    var note: Note?
    
    weak var delegate: AddNoteTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.delegate = self
        descriptionLabel.delegate = self
        phoneNumberLabel.delegate = self
        mailLabel.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNote))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImageTapped)))
        
        if self.note != nil {
            titleLable.text = note?.title
            phoneNumberLabel.text = note?.phoneNumber
            mailLabel.text = note?.mail
            descriptionLabel.text = note?.description
            imageView.image = note?.image
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd,yyyy  hh:mm:ss"
            guard let date = formatter.date(from: note!.date) else { return }
            datePicker.setDate(date, animated: false)
            
        }
    }
    
    
    @objc func cancelNote() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveNote() {
        guard !titleLable.text!.isEmpty,
            !descriptionLabel.text.isEmpty,
            !phoneNumberLabel.text!.isEmpty,
            !mailLabel.text!.isEmpty
            else { return }
        
        guard checkValidity(of: mailLabel.text!, pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}") else { return }
        guard checkValidity(of: phoneNumberLabel.text!, pattern: "^[0][0-9]{8}$") else { return }
        
        self.note = Note(title: titleLable.text!, phoneNumber: phoneNumberLabel.text!, mail: mailLabel.text!, description: descriptionLabel.text!, date: datePicker.date, image: imageView.image)
        
        if editMode {
            delegate?.updateNote(note: note!)
        } else {
            delegate?.saveNote(note: note!)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleLable.isFirstResponder {
            titleLable.resignFirstResponder()
            phoneNumberLabel.becomeFirstResponder()
        } else if phoneNumberLabel.isFirstResponder {
            phoneNumberLabel.resignFirstResponder()
            mailLabel.becomeFirstResponder()
        } else if mailLabel.isFirstResponder {
            mailLabel.resignFirstResponder()
            descriptionLabel.becomeFirstResponder()
        }
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var newText = textView.text!
        newText.removeAll { (character) -> Bool in
            return character == " " || character == "\n"
        }
        
        if (newText.count + text.count) <= 40 {
            textView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            print(newText.count + text.count - range.length)
            self.counterLabel.text = String(newText.count + text.count - range.length)
            return true
        } else {
            textView.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return false
        }
        
//        return (newText.count + text.count) <= 40
    }
    
    func checkValidity(of text: String, pattern: String) -> Bool {
        let regEx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return ((regEx?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count))) != nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.validContent()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == mailLabel || textField == phoneNumberLabel else { return }
        
        let patterns: [String] = ["^[0][0-9]{8}$", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"]
        if checkValidity(of: textField.text!, pattern: patterns[textField.tag]) {
            textField.validContent()
        } else {
            textField.invalidContent()
        }
            
    }
    
    //MARK: choose image
    @objc func chooseImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (ction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        }
    
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        }
    
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
    
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension UITextField {
    func invalidContent() {
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        self.backgroundColor = #colorLiteral(red: 0.9764636159, green: 0.9303435683, blue: 0.9364798665, alpha: 1)
    }
    
    func validContent() {
        self.layer.borderWidth = 0
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
