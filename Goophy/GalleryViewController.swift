//
//  GalleryViewController.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import UIKit

class GalleryViewController: UICollectionViewController {
    typealias Gif = GifResponse.GifObject.Image.Original

    private var gifs: [Gif] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareCollection()
        fetchGifs()
    }
    
    private func prepareUI() {
        title = "Goophy Gifs"
    }
    
    private func prepareCollection() {
        let layout = MosaicLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
    }
  
    private func fetchGifs() {
        // fetch gifs
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
        }
    }
}

//MARK: - Collection View Flow Layout

extension GalleryViewController: MosaicLayoutDelegate {
    
    public func heightForGif(at indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
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
