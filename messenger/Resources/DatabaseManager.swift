//
//  DatabaseManager.swift
//  messenger
//
//  Created by Лада Тирбах on 15.05.2021.
//

import Foundation
import Firebase


class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

extension DatabaseManager {
    private func getSafeEmail(email emailAddres: String) -> String {
        emailAddres.replacingOccurrences(of: "[@.#$\\[\\]]", with: "-", options: .regularExpression)
    }
    
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        database.child(getSafeEmail(email: email)).observeSingleEvent(of: .value) { shapshot in
            guard shapshot.value != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    /// Insert user to database
    public func addUser(with user: User) {
        database.child(getSafeEmail(email: user.emailAddress)).setValue([
            "name": user.name,
            "surname": user.surname
        ])
    }
    
}

struct User {
    let name: String
    let surname: String
    let emailAddress: String
    //let profilePictureUrl: String
}
