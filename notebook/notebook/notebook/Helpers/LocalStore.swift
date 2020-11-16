//
//  LocalStore.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/8/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class LocalStore {
    private static let appVersionKey = "APP_VERSION"
    private static let tokenKey = "TOKEN_KEY"
    private static let platformKey = "PLATFORM_KEY"
    private static let PhoneNumberKey = "PHONE_NUMBER_KEY"
    private static let EmailKey = "EMAIL_KEY"
    private static let UsernameKey = "USERNAME_KEY"
    private static let UserIdKey = "USER_ID_KEY"
    private static let FCMToken = "FCMToken"
    private static let genderKey = "GENDER"
    private static let birthDateKey = "BIRTHDATE"
    
    /**
     Stores App Version
     - Paramters appVersion: Value for APP_VERSION key
     */
    static func save(appVersion: String) {
        UserDefaults.standard.setValue(appVersion, forKey: appVersionKey)
    }
    
    /**
     Removes App Version
     */
    static func removeAppVersion() {
        UserDefaults.standard.removeObject(forKey: appVersionKey)
    }
    
    /**
     Returns App Version
     - return: App Version in string format
     */
    static func appVersion() -> String? {
        return UserDefaults.standard.string(forKey: appVersionKey)
    }
    
    static func upgrade(appVersion: String) {
        save(appVersion: appVersion)
    }
    
    static func save(token: String) {
        UserDefaults.standard.setValue(token, forKey: tokenKey)
    }

    static func removeToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    static func token() -> String? {
        return UserDefaults.standard.object(forKey: tokenKey) as? String
    }
    
    static func save(platform: String) {
        UserDefaults.standard.setValue(platform, forKey: platformKey)
    }
    
    static func removePlatform() {
        UserDefaults.standard.removeObject(forKey: platformKey)
    }
    
    static func platform() -> String? {
        return UserDefaults.standard.object(forKey: platformKey) as? String
    }
    
    static func save(phoneNumber: String) {
        UserDefaults.standard.setValue(phoneNumber, forKey: PhoneNumberKey)
    }
    
    static func removePhoneNumber() {
        UserDefaults.standard.removeObject(forKey: PhoneNumberKey)
    }
    
    static func phoneNumber() -> String? {
        return UserDefaults.standard.object(forKey: PhoneNumberKey) as? String
    }
    
    static func save(email: String) {
        UserDefaults.standard.setValue(email, forKey: EmailKey)
    }
    
    static func removeEmail() {
        UserDefaults.standard.removeObject(forKey: EmailKey)
    }
    
    static func email() -> String? {
        return UserDefaults.standard.object(forKey: EmailKey) as? String
    }
    
    static func save(username: String) {
        UserDefaults.standard.setValue(username, forKey: UsernameKey)
    }
    
    static func removeUsername() {
        UserDefaults.standard.removeObject(forKey: UsernameKey)
    }
    
    static func username() -> String? {
        return UserDefaults.standard.object(forKey: UsernameKey) as? String
    }
    
    static func save(id: String) {
        UserDefaults.standard.setValue(id, forKey: UserIdKey)
    }
    
    static func removeUserId() {
        UserDefaults.standard.removeObject(forKey: UserIdKey)
    }
    
    static func userId() -> String? {
        return UserDefaults.standard.object(forKey: UserIdKey) as? String
    }
    
    static func save(fcmToken: String) {
        UserDefaults.standard.setValue(fcmToken, forKey: FCMToken)
    }
    
    static func removeFCMToken() {
        UserDefaults.standard.removeObject(forKey: FCMToken)
    }
    
    static func fcmToken() -> String? {
        return UserDefaults.standard.object(forKey: FCMToken) as? String
    }
    
    static func save(gender: String) {
        UserDefaults.standard.setValue(gender, forKey: genderKey)
    }
    
    static func removeGender() {
        UserDefaults.standard.removeObject(forKey: genderKey)
    }
    
    static func gender() -> String? {
        return UserDefaults.standard.object(forKey: genderKey) as? String
    }
    
    static func save(birthdate: String) {
        UserDefaults.standard.setValue(birthdate, forKey: birthDateKey)
    }
    
    static func removeBirthdate() {
        UserDefaults.standard.removeObject(forKey: birthDateKey)
    }
    
    static func birthdate() -> String? {
        return UserDefaults.standard.object(forKey: birthDateKey) as? String
    }
    
    static func phoneNumberAndCountryCode(from value: String) -> (String, String){
        let countryCode = String(value.prefix(3))
        let phoneNumber = String(value.suffix(value.count - 3))
        return (countryCode, phoneNumber)
    }
}
