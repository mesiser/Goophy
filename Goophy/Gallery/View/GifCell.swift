//
//  GifCell.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Gifu
import UIKit

final class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: GIFImageView!
    
    func play(url: URL) {
        imageView.backgroundColor = .random
        imageView.startAnimatingGIF()
    }
    
    override func prepareForReuse() {
        imageView.prepareForReuse()
        imageView.image = nil
    }
}

extension Gifu.GIFImageView {
    public override func nuke_display(image: UIImage?, data: Data? = nil) {
        prepareForReuse()
        if let data = data {
            animate(withGIFData: data)
        } else {
            self.image = image
        }
    }
}
