//
//  FilmCollectionViewCell.swift
//  FirstPagePosterApp
//
//  Created by Igor on 08.09.2018.
//  Copyright © 2018 Gargolye. All rights reserved.
//

import UIKit

protocol MyCellDelegate: class {
    func cellWasPressed(film: String?, image: UIImage?, premiere: String?)
}

class FilmCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var posterImageViwe: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabell: UILabel!
    var delegat: MyCellDelegate?
    
    @IBAction func learnMoreButton(_ sender: UIButton) {
        delegat?.cellWasPressed(film: filmNameLabel.text,image: posterImageViwe.image, premiere: releaseDateLabell.text)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
