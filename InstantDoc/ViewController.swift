//
//  ViewController.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 11/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Photos

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var loginOrRegisterButton: UIButton!
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var registerUserName: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerEmailId: UITextField!
    @IBOutlet weak var registerMobile: UITextField!
    @IBOutlet weak var profilePicView: RoundedImageView!
    var isLogin = true
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.profilePicView.layer.borderColor = GlobalVariables.blue.cgColor
        self.profilePicView.layer.borderWidth = 2
        loginUserName.text = "kartikaecs@gmail.com"
        loginPassword.text = "123456"
        // Do any additional setup after loading the view, typically from a nib.
        self.registerView.isHidden = true
        self.loginView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logInViewClicked(_ sender: Any) {
        isLogin = true
        self.loginOrRegisterButton.setTitle("Login", for: .normal)
        self.registerView.isHidden = true
        self.loginView.isHidden = false
    }
    @IBAction func registerViewClicked(_ sender: Any) {
        isLogin = false
        self.loginOrRegisterButton.setTitle("Register", for: .normal)
        self.registerView.isHidden = false
        self.loginView.isHidden = true
    }
    
    func registerValidate() -> Bool {
        if (self.registerEmailId.text?.count)! > 0 && (self.registerPassword.text?.count)! > 0 {
            return true
        }
        return false
    }
    
    func loginValidate() -> Bool {
        if (self.loginUserName.text?.count)! > 0 && (self.loginPassword.text?.count)! > 0 {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if registerValidate() {
            self.loginOrRegisterButton.isEnabled = true
        } else {
            self.loginOrRegisterButton.isEnabled = false
        }
        
        if loginValidate() {
            self.loginOrRegisterButton.isEnabled = true
        } else {
            self.loginOrRegisterButton.isEnabled = false
        }
        
        return true
    }
    
    @IBAction func loginOrRegisterClicked(_ sender: Any) {
        if isLogin {
            Auth.auth().signIn(withEmail: loginUserName.text!, password: loginPassword.text!) { user, error in
                if let error = error, user == nil {
                    let alert = UIAlertController(title: "Sign In Failed",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                if error == nil {
                    self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "tabVC") as UIViewController, animated: true)
                }
            }
        } else {

            User.registerUser(withName: self.registerUserName.text!, email: self.registerEmailId.text!, password: self.registerPassword.text!, profilePic: self.profilePicView.image!) { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        weakSelf?.pushToMainView()
                        weakSelf?.profilePicView.image = UIImage.init(named: "profile pic")
                    } else {
//                        for item in (weakSelf?.waringLabels)! {
//                            item.isHidden = false
                        }
                    }
                }
            }        
    }
    
    func pushToMainView() {
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "tabVC") as UIViewController, animated: true)
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePicView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPic(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
}

