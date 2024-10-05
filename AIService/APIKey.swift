//
//  APIKey.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//

import Security
import Foundation

func saveAPIKey(key: String) -> Bool {
    // Convert password to Data
    let key = key.data(using: .utf8)!

    // Create query for adding to keychain
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "AIService",
        kSecAttrAccount as String: NSFullUserName(),
        kSecValueData as String: key
    ]

    // Check if item already exists
    SecItemDelete(query as CFDictionary)  // Delete any existing item

    // Add the new keychain item
    let status = SecItemAdd(query as CFDictionary, nil)

    return status == errSecSuccess
}

func getAPIKey() -> String? {
    // Create query to search for the keychain item
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "AIService",
        kSecAttrAccount as String: NSFullUserName(),
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var dataTypeRef: AnyObject? = nil

    // Search for the keychain item
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

    if status == errSecSuccess {
        if let key = dataTypeRef as? Data {
            // Convert data to string
            return String(data: key, encoding: .utf8)
        }
    }

    return nil;
}

func deleteAPIKey() -> Bool{
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "AIService",
        kSecAttrAccount as String: NSFullUserName()
    ]

    let status = SecItemDelete(query as CFDictionary)

    return status == errSecSuccess
}

