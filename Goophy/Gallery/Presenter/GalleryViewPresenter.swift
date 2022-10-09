//
//  GalleryViewPresenter.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//
import Combine
import Foundation

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
            .sink { [weak self] result in
                switch result {
                case .success(let response):
                    let newItems = response.data.compactMap { $0.images }
                    let reachedLimit = newItems.count == 0
                    self?.gifDataService.increaseOffset()
                    self?.delegate?.gifsFetchedWith(outcome: .success(newItems), reachedLimit: reachedLimit)
                case .failure(let error):
                    self?.delegate?.gifsFetchedWith(outcome: .error(error.localizedDescription), reachedLimit: false)
                }
            }
            .store(in: &anyCancellable)
    }
    
    func resetOffset() {
        gifDataService.setOffset(to: 0)
    }
}
