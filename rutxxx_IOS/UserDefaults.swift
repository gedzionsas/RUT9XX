//
//  UserDefaults.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 24/01/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation



class UserDefaultsManager {
    
    private static let SAVED_TOKEN = "saved_token"
    private static let SAVED_USERNAME = "saved_username"
    private static let SAVED_PASSWORD = "saved_password"
    
    private static let SAVE_PASSWORD = "save_password"
    
    
    
    static var setSavePasswordValue: String {
        get {
            return UserDefaults.standard.string(forKey: SAVE_PASSWORD)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVE_PASSWORD)
        }
    }
    
    static var setSaved_Token: String {
        get {
            return UserDefaults.standard.string(forKey: SAVED_TOKEN)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVED_TOKEN)
        }
    }
    
    
    static var setSaved_Username: String {
        get {
            return UserDefaults.standard.string(forKey: SAVED_USERNAME)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVED_USERNAME)
        }
    }
    static var setSaved_password: String {
        get {
            return UserDefaults.standard.string(forKey: SAVED_PASSWORD)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVED_PASSWORD)
        }
    }
    
}
