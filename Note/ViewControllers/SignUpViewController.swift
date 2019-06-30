//
//  SignUpViewController.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/25/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let fileManager = MyFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        //targets
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImageTapped)))
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
    
    @objc func signUpButtonTapped() {
        // MARK: SignUp
        usernameTextField.updateBorderColor()
        passwordTextField.updateBorderColor()
        guard !usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty else { return }
        
        var users = fileManager.readUserData() ?? []
        let newUser = User(username: usernameTextField.text!, password: passwordTextField.text!, image: imageView.image)

        if users.contains(newUser) {

            let alertController = UIAlertController(title: "User has already registered", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)

        } else {

            users.append(newUser)
            fileManager.writeUserData(users)

            let alertController = UIAlertController(title: "Registration completed successfully", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.usernameTextField.text!.removeAll()
                self.passwordTextField.text!.removeAll()
                self.imageView.image = nil
                self.tabBarController?.selectedIndex = 0
            }))
            self.present(alertController, animated: true, completion: nil)

        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
        
        return false
    }
    
}
