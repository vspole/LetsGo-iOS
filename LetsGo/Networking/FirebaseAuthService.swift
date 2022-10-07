//
//  FirebaseAuthService.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/6/22.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthServiceProtocol: AnyObject {
    func requestOTP(phoneNumber: String, completion: @escaping (String?, Error?) -> Void)
    func signInWithCode(code: String, verificationId: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
    func getUserIDToken(completion: @escaping (AuthTokenResult?) -> Void)
    func getCurrentUser() -> User?
    func isUserSignedIn() -> Bool
    func signOutUser()
}

class FirebaseAuthService: DependencyContainer.Component, FirebaseAuthServiceProtocol {
    func requestOTP(phoneNumber: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().languageCode = "en"
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            completion(verificationID, error)
        }
    }
    
    func signInWithCode(code: String, verificationId: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)

        Auth.auth().signIn(with: credential) { (authResult, error) in
            completion(authResult,error)
        }
    }
    
    func getUserIDToken(completion: @escaping (AuthTokenResult?) -> Void) {
        guard let currentUser = getCurrentUser() else {
            completion(nil)
            return
        }
        
        currentUser.getIDTokenResult(forcingRefresh: true) { idToken, error in
            completion(idToken)
        }
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func isUserSignedIn() -> Bool {
        return getCurrentUser() != nil
    }
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error: ", error)
        }
    }
}
