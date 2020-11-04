//
//  AccountManager.swift
//  Workout App
//
//  Created by Tabita Marusca on 28/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import Foundation
import Firebase

final class AccountManager {
    // MARK: - Properties
    
    private let isAuthenticatedKey = "isAuthenticated"
    private var isAuthenticated: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: isAuthenticatedKey)
        }
        get {
            return UserDefaults.standard.bool(forKey: isAuthenticatedKey)
        }
    }
    
    private let userIDKey = "userID"
    private var userID: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userIDKey)
        }
        get {
            return UserDefaults.standard.string(forKey: userIDKey)
        }
    }
    
    // MARK: - Internal Methods
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            if error == nil {
                self.isAuthenticated = true
                
                if let user = user {
                    self.userID = user.user.uid
                }
            }
            completion(error)
        }
    }
    
    func registerNewUser(email: String, password: String, username: String, completion: @escaping (Error?) -> ())  {
        // still need to save the username somehow
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            if error == nil {
                if let user = user {
                    self.userID = user.user.uid
                }
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { (error) in
                    if error != nil {
                        completion(error)
                    }
                }
                
                self.isAuthenticated = true
            }
            
            completion(error)
        }
    }
    
    func logout(completion: @escaping (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            userID = ""
            completion(nil)
        }
        catch {
            completion(error)
        }
    }
}
