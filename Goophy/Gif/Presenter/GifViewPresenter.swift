//
//  GifViewPresenter.swift
//  Goophy
//
//  Created by Vadim Shalugin on 29.03.2022.
//

import UIKit
import PhotosUI

enum SaveOperationResult {
    case success
    case error(String)
}

protocol GifViewPresenterInput {
    func save(image: UIImage, url: URL)
    func copyToClipboard(link: String)
}

protocol GifViewPresenterOutput: AnyObject {
    func gifSavedWith(outcome: SaveOperationResult)
    func copiedToClipboard()
}

final class GifViewPresenter: GifViewPresenterInput {
    
    weak var delegate: GifViewPresenterOutput?

    init(delegate: GifViewPresenterOutput) {
        self.delegate = delegate
    }
    
    private func vibrate() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}

//MARK: - Gif View Presenter Input

extension GifViewPresenter {
    
    func save(image: UIImage, url: URL) {

        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url) {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
                    }) { (success, error) in
                        DispatchQueue.main.async {
                            if let error = error {
                                self.delegate?.gifSavedWith(outcome: .error(error.localizedDescription))
                            } else {
                                self.vibrate()
                                self.delegate?.gifSavedWith(outcome: .success)
                            }
                        }
                    }
            }
        }
    }
    
    func copyToClipboard(link: String) {
        UIPasteboard.general.string = link
        vibrate()
        delegate?.copiedToClipboard()
    }
}
