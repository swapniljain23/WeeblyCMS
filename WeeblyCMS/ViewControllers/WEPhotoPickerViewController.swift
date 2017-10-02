//
//  WEPhotoPickerViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import Photos

class WEPhotoPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK:- Properties
    var photoAssets = [PHAsset]()
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let results = PHAsset.fetchAssets(with: .image, options: nil)
        results.enumerateObjects { (object, _, _) in
            self.photoAssets.append(object)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UICollectionView data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        guard let imageCell = cell as? ImageCollectionViewCell else{
            return cell
        }
        let imageManager = PHImageManager.default()
        let asset = photoAssets[indexPath.row]
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 120.0, height: 120.0), contentMode: .aspectFill, options: nil, resultHandler: { (result, _) in
            imageCell.imageView.image = result
        })
        return imageCell
    }
    
    // MARK:- UICollectionView delegate
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
