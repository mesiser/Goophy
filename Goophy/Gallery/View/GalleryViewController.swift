//
//  GalleryViewController.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Nuke
import UIKit

class GalleryViewController: UICollectionViewController {

    private var gifs: [Gif] = []
    private var presenter: GalleryViewPresenter?
    private var reachedLimit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        preparePresenter()
        fetchGifs()
    }
    
    private func prepareUI() {
        title = "Goophy Gifs"
    }
    
    private func preparePipeline() {
        let pipeline = ImagePipeline {
        let dataCache = try? DataCache(name: "com.shalugin.Goophy")
            dataCache?.sizeLimit = 200 * 1024 * 1024
            $0.dataCache = dataCache
        }
        ImagePipeline.shared = pipeline
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
    
    func gifsFetched(_ newGifs: [Gif], reachedLimit: Bool) {
        self.reachedLimit = reachedLimit
        gifs.append(contentsOf: newGifs)
        reloadCollection()
    }
    
    private func reloadCollection() {
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        let layout = MosaicLayout()
        layout.delegate = self
        self.collectionView.collectionViewLayout = layout
        self.collectionView.reloadData()
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
            let url = gifs[indexPath.row].downsized.videoURL
        else {
            return UICollectionViewCell()
        }

        let request = ImageRequest(
          url: url,
          processors: imageProcessors(for: gifs[indexPath.row])
        )

        Nuke.loadImage(with: request, into: cell.imageView)
        
        cell.play(url: url)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == gifs.count - 20, !reachedLimit {
            DispatchQueue.global(qos: .utility).async {
                self.presenter?.fetchGifs()
            }
        }
    }
    
    private func imageProcessors(for gif: Gif) -> [ImageProcessing] {
        
        let width = CGFloat(Float(gif.downsized.width) ?? 0)
        let height = CGFloat(Float(gif.downsized.height) ?? 0)
        let imageSize = CGSize(width: width, height: height)
        let resizedImageProcessors: [ImageProcessing] = [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
       
        return resizedImageProcessors
    }
}

//MARK: - Collection View Flow Layout

extension GalleryViewController: MosaicLayoutDelegate {

    func heightForGif(at indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let gifHeight = calculateHeight(for: gifs[indexPath.row], scaledToWidth: cellWidth)
        return gifHeight
    }

    private func calculateHeight(for gif: Gif, scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = CGFloat(Float(gif.downsized.width) ?? 0)
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = CGFloat(Float(gif.downsized.height) ?? 0) * scaleFactor
        return newHeight
    }
}

//MARK: - Collection View Delegate Methods

extension GalleryViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let gif = gifs[indexPath.row]
        let gifViewController = GifViewController.instantiate(fromAppStoryboard: .Main)
        gifViewController.gif = gif
        gifViewController.imageProcessors = imageProcessors(for: gif)
        navigationController?.pushViewController(gifViewController, animated: true)
    }
    
}
