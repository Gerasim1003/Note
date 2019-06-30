//
//  User.swift
//  Note
//
//  Created by Gerasim Israyelyan on 6/25/19.
//  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
//

import UIKit

struct User: Codable, Equatable {
    var username: String
    var password: String
    var image: UIImage?
    var notes = [Note]()
    
    init(username: String, password: String, image: UIImage?) {
        self.username = username
        self.password = password
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.username = try! container.decode(String.self, forKey: .username)
        self.password = try! container.decode(String.self, forKey: .password)
        
        if let imageData = try? container.decode(Data.self, forKey: .image) {
            if let image = UIImage(data: imageData) {
                self.image = image
            }
        }
        
        self.notes = try! container.decode([Note].self, forKey: .notes)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        
        if let data = image?.pngData() {
            try container.encode(data, forKey: .image)
        }
        
        try container.encode(notes, forKey: .notes)
    
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case image
        case notes
    }
    
    enum NotesCodingKeys: String, CodingKey {
        case notes
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.username == rhs.username) && (lhs.password == rhs.password)
        
    }
    
}

