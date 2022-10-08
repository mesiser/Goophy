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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var gif: Gif?
    var imageProcessors: [ImageProcessing] = []
    private var presenter: GifViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        preparePresenter()
        loadGif()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            guard let image = imageView.image, let url = gif?.original.videoURL else { return }
            makeActivityIndicator(visible: true)
            presenter?.save(image: image, url: url)
        case 1:
            guard let link = gif?.original.url else { return }
            presenter?.copyToClipboard(link: link)
        default:
            break
        }
    }
    
    //MARK: - Private
    
    private func prepareUI() {
        makeActivityIndicator(visible: false)
    }
    
    private func preparePresenter() {
        presenter = GifViewPresenter(delegate: self)
    }
    
    private func loadGif() {
        guard let gif = gif, let url = gif.original.videoURL else { return }
        let request = ImageRequest(
            url: url,
            processors: imageProcessors
        )

        Nuke.loadImage(with: request, into: imageView)
    }
    
    private func makeActivityIndicator(visible: Bool) {
        activityIndicator.isHidden = !visible
        visible ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

//MARK: - Gif View Presenter Delegate

extension GifViewController: GifViewPresenterOutput {
    
    func gifSaved(outcome: OperationResult) {
        makeActivityIndicator(visible: false)
        switch outcome {
        case .success:
            let ac = UIAlertController(title: "Saved!", message: "Gif has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        case .error(let error):
            let ac = UIAlertController(title: "Save error", message: error, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func copiedToClipboard() {
        let ac = UIAlertController(title: "Copied!", message: "Link has been copied to clipboard.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
