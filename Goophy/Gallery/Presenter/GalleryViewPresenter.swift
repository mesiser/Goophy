//
//  GalleryViewPresenter.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//
import Combine
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
    private var anyCancellable = Set<AnyCancellable>()

    weak var delegate: GalleryViewPresenterOutput?
    
    init(delegate: GalleryViewPresenterOutput) {
        self.delegate = delegate
    }

    func fetchGifs(for category: GifCategory) {
        
        gifDataService.fetchGifs(for: category)
            .sink { receiveCompletion in
                switch receiveCompletion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Error \(error)")
                }
            } receiveValue: { [weak self] response in
                let newItems = response.data.compactMap { $0.images }
                let reachedLimit = newItems.count == 0
                self?.gifDataService.increaseOffset()
                self?.delegate?.gifsFetchedWith(outcome: .success(newItems), reachedLimit: reachedLimit)
            }.store(in: &anyCancellable)
    }
    
    func resetOffset() {
        gifDataService.setOffset(to: 0)
    }
}
