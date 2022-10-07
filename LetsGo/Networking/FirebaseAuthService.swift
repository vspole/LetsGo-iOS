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
}
