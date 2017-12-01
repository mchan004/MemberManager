//
//  ShowImageCollectionViewCell.swift
//  MemberManager
//
//  Created by Administrator on 12/1/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class ShowImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 8.0
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
