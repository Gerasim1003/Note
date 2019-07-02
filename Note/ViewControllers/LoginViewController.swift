//
//  LoginViewController.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/25/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let fileManager = MyFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        //targets
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
    
    @objc func loginButtonTapped() {
        usernameTextField.updateBorderColor()
        passwordTextField.updateBorderColor()
        guard !usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty else { return }

        
        let user = User(username: usernameTextField.text!, password: passwordTextField.text!, image: nil)
        if let users = fileManager.readUserData(), users.contains(user) {
            let index = users.lastIndex { (usser) -> Bool in
                return usser == user
            }
            if let index = index {
                guard let notesVC = self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as? NotesTableViewController else { return }
                notesVC.user = users[index]
                let navVC = UINavigationController(rootViewController: notesVC)
                self.present(navVC, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Login failed", message: "Invalid username or password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

}

extension UITextField {
    func updateBorderColor() {
        if self.text!.isEmpty {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 0.5
            self.layer.cornerRadius = 5
        } else {
            self.layer.borderWidth = 0
        }
        
    }
    
}
