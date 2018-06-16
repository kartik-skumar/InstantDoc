//
//  User.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 23/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit
import CoreFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class User: NSObject {
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                user?.user.sendEmailVerification(completion: nil)
                let storageRef = Storage.storage().reference().child("usersProfilePics").child(user!.user.uid)
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        let path = storageRef.fullPath
                        let values = ["name": withName, "email": email, "profilePicLink": path]
                        Database.database().reference().child("users").child((user?.user.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                let userInfo = ["email" : email, "password" : password]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
                            }
                        })
                    }
                })
            }
            else {
                completion(false)
            }
        })
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let link = URL.init(string: data["profilePicLink"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                
                let storage = Storage.storage()
                // Create a storage reference from our storage service
                let storageRef = storage.reference()
                let imageRef = storageRef.child(credentials["profilePicLink"]!)
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error == nil {
                        // Data for "images/island.jpg" is returned
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!)
                        completion(user)
                    }
                }
                
//                let link = URL.init(string: credentials["profilePicLink"]!)
//                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
//                    if error == nil {
//                        let profilePic = UIImage.init(data: data!)
//                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!)
//                        completion(user)
//                    }
//                }).resume()
            }
        })
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    
    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }

}
