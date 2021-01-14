//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by Renan Baialuna on 14/01/21.
//

import UIKit

class DetailMemeViewController: UIViewController {

    var meme: Meme!
    @IBOutlet weak var memeimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memeimage.image = meme.memedImage
    }

}
