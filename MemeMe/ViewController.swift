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
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    var activeTextField: UITextField?
    var memedImage: UIImage?

    
// MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
        pickImageSource(source: .camera)
    }
    
    @IBAction func pickFromAlbum() {
        pickImageSource(source: .photoLibrary)
    }
    
    func pickImageSource(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func share() {
        let memedImage = generateMemedImage()
        self.memedImage = memedImage
        let ac = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
        
        ac.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
                                            Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if completed {
                    self.save()
                } else {
                    print("cancel")
                }
            }
        }
    }
    
// MARK: Save function
    
    func save() {
        if let topText = self.topTextField.text, let bottonText = self.bottonTextField.text, let original = displayImage.image, let meme = self.memedImage {
            let meme = Meme(topText: topText, bottonText: bottonText, originalImage: original, memedImage: meme)
        }
    }
    
// MARK: keyboard behavior
    
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
    
// MARK: Generate image for sharing
    
    func generateMemedImage() -> UIImage {

        navigationController?.setNavigationBarHidden(true, animated: false)
        toolBar.isHidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        toolBar.isHidden = false

        return memedImage
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
            if self.displayImage.image != nil {
                shareButton.isEnabled = true
            } else {
                shareButton.isEnabled = false
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

