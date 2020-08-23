//
//  CaptureViewVC.swift
//  aiksixer
//
//  Created by Shishir Ahmed on 9/8/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit
import Photos

protocol ModalDelegate:class {
    func changeValue(value: [UIImage])
}

class CaptureViewVC: UIViewController{

    //MARK:: Properties
    
    weak var delegate: ModalDelegate?
    var imageTake: UIImage!
    
    var selectedImage = [UIImage]()
    var imageArray = [UIImage]()
    var selectedIndex = [Int]()
    
    @IBOutlet weak var selectedCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        grabPhotos()
        
        selectedCollection.delegate = self
        selectedCollection.dataSource = self
        selectedCollection.allowsMultipleSelection = true
        
        selectedCollection.register(SelectedCell.nib(), forCellWithReuseIdentifier: SelectedCell.identfier)
    }
    
    //MARK:: Functions
    
    func grabPhotos(){
        imageArray = [UIImage]()
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions){
            if fetchResult.count > 0{
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions) { (image, error) in
                        self.imageArray.append(image!)
                    }
                }
            }else{
                print("No image found")
            }
        }
        self.selectedCollection.reloadData()
    }
    
    //MARK:: Actions

    @IBAction func cameraPressed(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        delegate?.changeValue(value: selectedImage)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CaptureViewVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedCell.identfier, for: indexPath) as! SelectedCell
        
        cell.configure(image: imageArray[indexPath.row].resized(toWidth: 95 ))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selectedCollection.frame.size.width / 3 - 8 , height: selectedCollection.frame.size.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.isSelected == true {
            cell?.backgroundColor = .white
        }
        
        selectedIndex.append(indexPath.item)
        selectedImage.append(imageArray[indexPath.item])
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .gray
    }
    
}

extension CaptureViewVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard (info[.editedImage] as? UIImage) != nil else {
            print("No image found")
            return
        }
        imageTake = info[.editedImage] as? UIImage
        UIImageWriteToSavedPhotosAlbum(imageTake!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            self.grabPhotos()
        }
    }
}
