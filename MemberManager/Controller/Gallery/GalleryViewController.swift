//
//  GalleryViewController.swift
//  MemberManager
//
//  Created by Administrator on 12/6/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonSelect: UIBarButtonItem!
    @IBOutlet weak var buttonView: UIBarButtonItem!
    
    var isMultiSelect: Bool = false {
        didSet {
            if isMultiSelect {
                buttonSelect.title = "Cancel"
                isButtonViewEnable = true
                
            } else {
                buttonSelect.title = "Select"
                isButtonViewEnable = false
                
                guard let selectedItems = collectionView.indexPathsForSelectedItems else {
                    return
                }
                title = ""
                for i in selectedItems {
                    collectionView.deselectItem(at: i, animated: true)
                }
            }
        }
    }
    
    var isButtonViewEnable: Bool = false {
        didSet {
            if isButtonViewEnable {
                buttonView.title = "View"
                buttonView.isEnabled = true
            } else {
                buttonView.title = ""
                buttonView.isEnabled = false
            }
        }
    }
    
    
    var arrayImage: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchImage()
        fetchImage()
        collectionView.allowsMultipleSelection = true
        isButtonViewEnable = false
    }
    
    func fetchImage() {
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            var aI: [UIImage] = []
            for i in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                    aI.append(image!)
                })
            }
            self.arrayImage = aI
            collectionView.reloadData()
        } else {
            print("You got not photos!")
        }
    }
    
    
    
    @IBAction func handleMultiSelect(_ sender: Any) {
        isMultiSelect = !isMultiSelect
    }
    @IBAction func didSelectView(_ sender: UIBarButtonItem) {
        sender.tintColor = #colorLiteral(red: 0.01825479046, green: 0.4770008922, blue: 0.9854133725, alpha: 1)
        self.performSegue(withIdentifier: "showImagesIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identify = segue.identifier
        if identify == "showImagesIdentifier" {
            if let selectedItems = collectionView.indexPathsForSelectedItems {
                let vc = segue.destination as! MultiImageViewController
                for i in selectedItems {
                    vc.imageArray.append(arrayImage[i.item])
                }
            }
        }
    }
}



//
// CollectionView
//
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryCollectionViewCell
        cell.imageView.image = arrayImage[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isMultiSelect {
            if let selectedItems = collectionView.indexPathsForSelectedItems {
                title = "\(selectedItems.count) images selected"
            }
            
            return
        }
        
        NotificationCenter.default.post(name: .init("SelectedImage"), object: arrayImage[indexPath.item])
        _ = navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            title = "\(selectedItems.count) images selected"
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 4 - 1, height: collectionView.frame.size.width / 4 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}







extension GalleryViewController {
    
}

















class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    
    override var isSelected: Bool {
        didSet {
            selectedView.isHidden = !selectedView.isHidden
        }
    }
    
}
