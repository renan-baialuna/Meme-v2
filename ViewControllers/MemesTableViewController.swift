//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Renan Baialuna on 11/01/21.
//

import UIKit

class MemesTableViewController: UIViewController {
    var memes: [Meme] = []
    @IBOutlet var memesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        memesTable.delegate = self
        memesTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        memesTable.reloadData()
    }

}

extension MemesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        cell.memeLabel.text = "\(meme.topText) - \(meme.bottonText)"
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    
}
