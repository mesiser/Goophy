//
//  GalleryViewPresenter.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//
import Foundation

typealias Gif = GifResponse.GifObject.Image
typealias GifCategory = GifDataService.GifCatergory

enum GifFetchResult {
    case success([Gif])
    case error(String)
}

protocol GalleryViewPresenterInput {
    func fetchGifs(for category: GifCategory)
    func resetOffset()
}

protocol GalleryViewPresenterOutput: AnyObject {
    func gifsFetchedWith(outcome: GifFetchResult, reachedLimit: Bool)
}

final class GalleryViewPresenter: GalleryViewPresenterInput {
    
    private let gifDataService = GifDataService()
    
    weak var delegate: GalleryViewPresenterOutput?
    
    init(delegate: GalleryViewPresenterOutput) {
        self.delegate = delegate
    }

    func fetchGifs(for category: GifCategory) {
        
        gifDataService.fetchGifs(for: category) { [weak self] response, failed in
            if let failed = failed {
                self?.delegate?.gifsFetchedWith(outcome: .error(failed.message ?? "Unknown error"), reachedLimit: false)
            }
            
            guard let self = self, let response = response else {
                return
            }

            let newItems = response.data.compactMap { $0.images }
            let reachedLimit = newItems.count == 0
            self.gifDataService.currentOffset += self.gifDataService.gifsPerPage
            self.delegate?.gifsFetchedWith(outcome: .success(newItems), reachedLimit: reachedLimit)
        }
    }
    
    func resetOffset() {
        gifDataService.currentOffset = 0
    }
}
