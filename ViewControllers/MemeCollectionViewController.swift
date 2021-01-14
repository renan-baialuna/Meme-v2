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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
// MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeCollection.delegate = self
        memeCollection.dataSource = self

        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 2.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        memeCollection.reloadData()
    }
}

// MARK: collection control

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        controller.meme = memes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
