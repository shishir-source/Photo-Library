//
//  ShowFileVC.swift
//  aiksixer
//
//  Created by Shishir Ahmed on 8/8/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit

class ShowFileVC: UIViewController {
    
    //MARK:: Properties
    
    var selectedImage = [UIImage]()
    
    @IBOutlet weak var selectedCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedCollection.delegate = self
        selectedCollection.dataSource = self
        
        selectedCollection.register(SelectedCell.nib(), forCellWithReuseIdentifier: SelectedCell.identfier)
    }
    
    //MARK:: Actions

}

extension ShowFileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedCell.identfier, for: indexPath) as! SelectedCell
        
        cell.backgroundColor = .white
        cell.configure(image: selectedImage[indexPath.row].resized(toWidth: 95 ))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selectedCollection.frame.size.width / 3 - 8 , height: selectedCollection.frame.size.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
