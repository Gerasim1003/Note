//
//  Note.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/26/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

struct Note: Codable {
    var id: String?
    var title: String
    var phoneNumber: String
    var mail: String
    var description: String
    var image: UIImage?
    var date: String
    
    init(id: String? = nil, title: String, phoneNumber: String, mail: String, description: String, date: Date,
        image: UIImage? = nil) {
        self.id = id
        if self.id == nil {
            self.id = "\(Date.timeIntervalSinceReferenceDate)".components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        }
        self.title = title
        self.phoneNumber = phoneNumber
        self.mail = mail
        self.description = description
        self.image = image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd,yyyy  hh:mm:ss"
        let date = formatter.string(from: date)
        
        self.date = date
    }
    
    func toAny() -> Any {
        return ["title": title,
                "description": description,
                "phoneNumber": phoneNumber,
                "mail": mail,
                "date": date]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try! container.decode(String.self, forKey: .id)
        self.title = try! container.decode(String.self, forKey: .title)
        self.phoneNumber = try! container.decode(String.self, forKey: .phoneNumber)
        self.mail = try! container.decode(String.self, forKey: .mail)
        self.description = try! container.decode(String.self, forKey: .description)
        self.date = try! container.decode(String.self, forKey: .date)

        if let imageData = try? container.decode(Data.self, forKey: .image) {
            if let image = UIImage(data: imageData) {
                self.image = image
            }
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
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
        case id
        case title
        case phoneNumber
        case mail
        case description
        case date
        case image
    }
    
}
