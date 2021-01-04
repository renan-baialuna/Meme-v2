//
//  ViewController.swift
//  MemeMe
//
//  Created by Renan Baialuna on 04/01/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var displayImage: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottonTextField: UITextField!
    
    var activeTextField: UITextField?

    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpUI()
        subscribeToKeyboardNotification()
        self.topTextField.delegate = self
        self.bottonTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
    }
    
    // MARK:initial UI setup
    
    func setUpUI() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor:  UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -5,
            NSAttributedString.Key.paragraphStyle : paragraph
        ]
        
        self.topTextField.backgroundColor = UIColor.clear
        self.bottonTextField.backgroundColor = UIColor.clear
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottonTextField.defaultTextAttributes = memeTextAttributes
    }

// MARK: buttons actions
    
    @IBAction func takePickture() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickFromAlbum() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
// MARK: keyboar behavior
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let active = self.activeTextField {
            let botton = active.frame.origin.y + active.frame.height
            if botton > getKeyboardHeight(notification) {
                view.frame.origin.y = -getKeyboardHeight(notification)
            }
        }
        
    }
    
    @objc func keyboardWillDisapear(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                            selector: #selector(keyboardWillShow(_:)),
                                            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisapear(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: text field delegate

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: image picker delegates

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.displayImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

