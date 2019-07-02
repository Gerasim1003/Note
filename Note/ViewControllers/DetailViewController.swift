//
//  DetailViewController.swift
//  Note
//
//  Created by Gerasim Israyelyan on 7/2/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var note: Note!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = note.title
        phoneNumberLabel.text = note.phoneNumber
        mailLabel.text = note.mail
        dateLabel.text = note.date
        descriptionTextView.text = note.description

        if let image = note.image {
            imageView.image = image
        } else {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        
        //setShadow
        detailView.setShadow()
        
    }
    
    @objc func cancelButton() {
        dismiss(animated: true, completion: nil)
    }

}
