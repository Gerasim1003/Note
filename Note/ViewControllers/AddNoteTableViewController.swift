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
}

class AddNoteTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var titleLable: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var mailLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: AddNoteTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.delegate = self
        phoneNumberLabel.delegate = self
        mailLabel.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNote))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImageTapped)))
        
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
        
        let note = Note(title: titleLable.text!, phoneNumber: phoneNumberLabel.text!, mail: mailLabel.text!, description: descriptionLabel.text!, date: datePicker.date, image: imageView.image)
        delegate?.saveNote(note: note)
        
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
