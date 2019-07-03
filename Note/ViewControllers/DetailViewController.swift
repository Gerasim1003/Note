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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    
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
        
        let imageViewWidth = self.view.frame.width - 40
        let imageViewHeight = imageViewWidth / 2
        imageViewWidthConstraint.constant = imageViewWidth
        imageViewHeightConstraint.constant = imageViewHeight
        
        if UIDevice.current.orientation.isPortrait {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            
            let viewHeight = self.view.frame.height
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            
            var descriptionViewHeight = viewHeight - imageViewHeight - statusBarHeight - 293
            descriptionViewHeight -= topPadding ?? 0
            descriptionViewHeight -= bottomPadding ?? 0
            if let navBarHeight = self.navigationController?.navigationBar.frame.height {
                descriptionViewHeight -= navBarHeight
            }
            
            self.descriptionTextViewHeightConstraint.constant = descriptionViewHeight
            descriptionTextView.layoutIfNeeded()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let imageViewWidth = size.width - 40
        let imageViewHeight = imageViewWidth / 2
        self.imageViewWidthConstraint.constant = imageViewWidth
        self.imageViewHeightConstraint.constant = imageViewHeight
        imageView.layoutIfNeeded()

    }
    
    @objc func cancelButton() {
        dismiss(animated: true, completion: nil)
    }

}
