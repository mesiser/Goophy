//
//  GalleryViewController.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import UIKit

class GalleryViewController: UICollectionViewController {

    private var gifs: [Gif] = []
    private var presenter: GalleryViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        preparePresenter()
        fetchGifs()
    }
    
    private func prepareUI() {
        title = "Goophy Gifs"
    }
                                          
    private func preparePresenter() {
        presenter = GalleryViewPresenter(delegate: self)
    }
  
    private func fetchGifs() {
        presenter?.fetchGifs()
    }
}

//MARK: - Gallery View Presenter Output

extension GalleryViewController: GalleryViewPresenterOutput {
    
    func gifsFetched(_ newGifs: [Gif]) {
        gifs.append(contentsOf: newGifs)
        reloadCollection()
    }
    
    private func reloadCollection() {
        collectionView.collectionViewLayout.invalidateLayout()
        let layout = MosaicLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
}

// MARK: - Collection View Data Source Methods

extension GalleryViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as? GifCell,
            let url = gifs[indexPath.row].videoURL
        else {
            return UICollectionViewCell()
        }
        
        cell.play(url: url)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == gifs.count - 20 {
            print("The end is near 🔔")
            presenter?.fetchGifs()
        }
    }
}

//MARK: - Collection View Flow Layout

extension GalleryViewController: MosaicLayoutDelegate {
    
    func heightForGif(at indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let gifHeight = calculateHeight(for: gifs[indexPath.row], scaledToWidth: cellWidth)
        return gifHeight
    }

    private func calculateHeight(for gif: Gif, scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = CGFloat(Float(gif.width) ?? 0)
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = CGFloat(Float(gif.height) ?? 0) * scaleFactor
        return newHeight
    }
}

//MARK: - Collection View Delegate Methods

extension GalleryViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // navigate to full view
    }
}
