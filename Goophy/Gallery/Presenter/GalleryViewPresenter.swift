//
//  GalleryViewPresenter.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//
typealias Gif = GifResponse.GifObject.Image.Original

protocol GalleryViewPresenterInput {
    func fetchGifs()
}

protocol GalleryViewPresenterOutput: AnyObject {
    func gifsFetched(_ newGifs: [Gif])
}

import Foundation

final class GalleryViewPresenter: GalleryViewPresenterInput {
    
    private let gifDataService = GifDataService()
    private var reachedLimit = false
    
    weak var delegate: GalleryViewPresenterOutput?
    
    init(delegate: GalleryViewPresenterOutput) {
        self.delegate = delegate
    }

    func fetchGifs() {
        
        gifDataService.fetchGifs { [weak self] response, failed in
            if let failed = failed {
                print("Failed \(failed.message)")
            }
            
            guard let self = self, let response = response else {
                return
            }

            let newItems = response.data.compactMap { $0.images.original }
            self.reachedLimit = newItems.count == 0
            self.gifDataService.currentOffset += self.gifDataService.gifsPerPage
            self.delegate?.gifsFetched(newItems)
        }
    }
}
