//
//  NotesTableViewCell.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/26/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

protocol NotesTableViewCellDelegate: class {
    func callAlert(phoneNumber: String)
    func sendMail(mail: String)
}

class NotesTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView?
    
    weak var delegate: NotesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Targerts
        phoneNumberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneNumbertapped)))
        mailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mailLabeltapped)))
        
        //shadow
        cellView.setShadow()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    func setup(with note: Note) {
        self.noteTitleLabel.text = note.title
        self.phoneNumberLabel.text = note.phoneNumber
        self.mailLabel.text = note.mail
        self.descriptionLabel.text = note.description
        self.cellImageView?.image = note.image
        self.dateLabel.text = note.date
        
    }
    
    @objc func phoneNumbertapped() {
        delegate?.callAlert(phoneNumber: phoneNumberLabel.text!)
    }
    
    
    @objc func mailLabeltapped() {
        delegate?.sendMail(mail: mailLabel.text!)
    }

}

//MARK: UIView extention / setShadow()
extension UIView {
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1.5
    }
}
