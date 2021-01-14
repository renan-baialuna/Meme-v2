//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Renan Baialuna on 12/01/21.
//

import UIKit

class MemeCollectionViewController: UIViewController {
    var memes: [Meme] = []
    @IBOutlet weak var memeCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeCollection.delegate = self
        memeCollection.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        memeCollection.reloadData()
        
    }
}

extension MemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate     {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImage.image = meme.memedImage
        return cell
    }
    
    
}
