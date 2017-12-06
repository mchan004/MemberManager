//
//  ShowImageCollectionViewController.swift
//  MemberManager
//
//  Created by Administrator on 12/1/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit
import Photos

class ShowImageCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ImageStatic.arrayImage.count == 0 {
            fetchAlbums()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToImage(_:)), name: NSNotification.Name("SelectImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func orientationDidChange(_ notification: NSNotification) {
        
    }
    
    var current: Int!
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let offset = Int(collectionView.contentOffset.x)
        let width = Int(collectionView.frame.size.width)
        collectionView.collectionViewLayout.invalidateLayout()
        if width == 0 {
            return
        }
        current = offset / width
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if current > ImageStatic.arrayImage.count {
            return
        }
        print(current)
        let indexp = IndexPath(item: current, section: 0)
        collectionView.scrollToItem(at: indexp, at: .right, animated: false)
    }
    @objc func scrollToImage(_ notification: Notification) {
        if let id = notification.object as? Int {
            index = id
            self.srollToItem(id: index)
        }
    }
    
    func srollToItem(id: Int) {
        let indexp = IndexPath(item: id, section: 0)
        collectionView.scrollToItem(at: indexp, at: .right, animated: true)
    }

    func fetchAlbums() {
        // Get all user albums
        //        let allMedia = PHAsset.fetchAssetsWithOptions(fetchOptions)
        //        let allPhotos = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        //        let allVideo = PHAsset.fetchAssetsWithMediaType(.Video, options: fetchOptions)
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                    ImageStatic.arrayImage.append(image!)
                })
            }
        } else {
            print("You got not photos!")
            self.collectionView.reloadData()
        }
        
        
    }
    @IBAction func handleOk(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.init("SelectedImage"), object: index)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}


extension ShowImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageStatic.arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShowImageCollectionViewCell
        cell.imageView.image = ImageStatic.arrayImage[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Get current index item
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let point = collectionView.indexPathForItem(at: visiblePoint) {
            index = point.item
        }
        
    }
}

//////////
//Camera//
//////////
extension ShowImageCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            NotificationCenter.default.post(name: Notification.Name.init("TakedPhoto"), object: pickedImage)
        }
    }
}
