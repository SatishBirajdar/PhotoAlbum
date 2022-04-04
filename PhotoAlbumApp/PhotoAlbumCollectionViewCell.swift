//
//  PhotoAlbumCollectionViewCell.swift
//  PhotoAlbumApp
//
//  Created by satishbirajdar on 2022-04-03.
//

import UIKit
import Kingfisher

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var albumIdLabel: UILabel!
   
    func configure(urlString: String, name: String){
        let url = URL(string: urlString)
        if let url = url {
            thumnailImageView.kf.setImage(with: url)
        }
        albumIdLabel.text = name
        
        super.layoutSubviews()
    }
}
