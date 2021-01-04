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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpUI()
    }
    
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

    @IBAction func takePickture() {
        print("pickture")
    }
    
    @IBAction func pickFromAlbum() {
        print("album")
    }
}

