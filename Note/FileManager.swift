////
////  FileManager.swift
////  Note
////
////  Created by Gerasim Israyelyan on 6/26/19.
////  Copyright © 2019 Gerasim Israyelyan. All rights reserved.
////
//
//import UIKit
//
//class MyFileManager {
//
//    enum Component: String {
//        case Users = "users.plist"
//        case Notes = "notes.plist"
//    }
//
////    User
//    func readUserData() -> [User]? {
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let archiveURL = documentsDirectory.appendingPathComponent("users.plist")
//        let pListDecoder = PropertyListDecoder()
//        if let retrievedUserData = try? Data(contentsOf: archiveURL),
//            let decodedUsers = try? pListDecoder.decode([User].self, from: retrievedUserData) {
//            return decodedUsers
//        }
//        return nil
//    }
//
//    func writeUserData(_ data: [User]) {
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let archiveURL = documentsDirectory.appendingPathComponent("users.plist")
//        let pListEncoder = PropertyListEncoder()
//        let encodedUsers = try? pListEncoder.encode(data)
//        try? encodedUsers?.write(to: archiveURL)
//    }
//
//    func updateUserNotes(user: User) {
//        var users = readUserData()
//        guard users != nil else {return}
//
//        if let index = users?.lastIndex(where: { (usr) -> Bool in
//            usr == user
//        }) {
////            users![index].notes.append(note)
//            users![index].notes = user.notes
//        }
//
//        writeUserData(users!)
//    }
//}
