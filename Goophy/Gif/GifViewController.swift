//
//  GifViewController.swift
//  Goophy
//
//  Created by Vadim Shalugin on 29.03.2022.
//

import Gifu
import Nuke
import UIKit

final class GifViewController: UIViewController {
    
    @IBOutlet weak var imageView: GIFImageView!
    
    var gif: Gif?
    var imageProcessors: [ImageProcessing] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGif()
    }
    
    private func loadGif() {
        guard let gif = gif, let url = gif.original.videoURL else { return }
        let request = ImageRequest(
            url: url,
            processors: imageProcessors
        )

        Nuke.loadImage(with: request, into: imageView)
    }
}
