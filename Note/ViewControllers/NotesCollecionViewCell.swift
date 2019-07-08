//
//  NotesCollecionViewCell.swift
//  Note
//
//  Created by Gerasim Israyelyan on 7/8/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

class NotesCollecionViewCell: UICollectionViewCell {
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView?
    
    weak var delegate: NotesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //shadow
        self.setShadow()
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    func setup(with note: Note) {
        self.noteTitleLabel.text = note.title
        self.descriptionLabel.text = note.description
        self.cellImageView?.image = note.image
        
    }
    
}
