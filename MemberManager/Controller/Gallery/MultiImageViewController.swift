//
//  MultiImageViewController.swift
//  MemberManager
//
//  Created by Administrator on 12/6/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class MultiImageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageArray: [UIImage] = []
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: .UIDeviceOrientationDidChange, object: nil)
        pageControl.currentPage = 0
        pageControl.numberOfPages = imageArray.count
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        currentPage = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let indexp = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexp, at: .right, animated: false)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            collectionView.layout.itemSize = (size.width < size.height) ? itemSizeForPortraitMode : itemSizeForLandscapeMode
//            collectionView.layout.invalidateLayout()
//        }
//
//
//        let indexp = IndexPath(item: currentPage, section: 0)
//        collectionView.scrollToItem(at: indexp, at: .right, animated: false)
//    }
    
    
}

extension MultiImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellForMultiImage
        cell.imageView.image = imageArray[indexPath.item]
        return cell
    }
}

extension MultiImageViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentP = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        pageControl.currentPage = Int(currentP)
    }
}



class CellForMultiImage: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
