//
//  Note.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/26/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

struct Note: Codable {
    var title: String
    var phoneNumber: String
    var mail: String
    var description: String
    var image: UIImage?
    var date: Date
    
    init(title: String,phoneNumber: String, mail: String, description: String, date: Date,
        image: UIImage? = nil) {
        self.title = title
        self.phoneNumber = phoneNumber
        self.mail = mail
        self.description = description
        self.date = date
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try! container.decode(String.self, forKey: .title)
        self.phoneNumber = try! container.decode(String.self, forKey: .phoneNumber)
        self.mail = try! container.decode(String.self, forKey: .mail)
        self.description = try! container.decode(String.self, forKey: .description)
        self.date = try! container.decode(Date.self, forKey: .date)

        if let imageData = try? container.decode(Data.self, forKey: .image) {
            if let image = UIImage(data: imageData) {
                self.image = image
            }
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(mail, forKey: .mail)
        try container.encode(description, forKey: .description)
        try container.encode(date, forKey: .date)
        
        if let data = image?.pngData() {
            try container.encode(data, forKey: .image)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case phoneNumber
        case mail
        case description
        case date
        case image
    }
    
}
