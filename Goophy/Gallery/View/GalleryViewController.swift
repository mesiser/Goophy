//
//  GifGalleryViewController.swift
//  Goophy
//
//  Created by Vadim Shalugin on 29.03.2022.
//

import Nuke
import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var arrowView: UIView!
    
    private var gifs: [Gif] = []
    private var presenter: GalleryViewPresenterInput?
    private var reachedLimit = false
    private var selectedCategory: GifCategory = .trending
    
    weak var coordinator: AppCoordinatorOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        preparePresenter()
        fetchGifs()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        guard let newCategory = GifCategory(from: sender.selectedSegmentIndex) else { return }
        selectedCategory = newCategory
        refresh()
    }
    
    @IBAction func arrowUpTapped(_ sender: Any) {
        collectionView.setContentOffset(.zero, animated: true)
        setArrowView(visible: false)
    }
    
    private func prepareUI() {
        navigationItem.title = "Goophy Gifs"
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .systemBackground
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
        presenter?.fetchGifs(for: selectedCategory)
    }
    
    @objc
    func refresh() {
        gifs = []
        setArrowView(visible: false)
        collectionView.reloadData()
        reachedLimit = false
        presenter?.resetOffset()
        presenter?.fetchGifs(for: selectedCategory)
    }
    
    private func setArrowView(visible: Bool) {
        arrowView.isHidden = !visible
    }
}

//MARK: - Gallery View Presenter Output

extension GalleryViewController: GalleryViewPresenterOutput {
    
    func gifsFetchedWith(outcome: GifFetchResult, reachedLimit: Bool) {
        if collectionView.refreshControl?.isRefreshing ?? false {
            collectionView.refreshControl?.endRefreshing()
        }
        
        switch outcome {
        case .success(let newGifs):
            self.reachedLimit = reachedLimit
            gifs.append(contentsOf: newGifs)
            reloadCollection()
        case .error(let message):
            let ac = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as? GifCell else {
            return UICollectionViewCell()
        }
        
        cell.shimmer()
        
        let gif = gifs[indexPath.row]
        let url = gif.downsized.videoURL

        let request = ImageRequest(
            url: url,
            processors: gif.imageProcessors()
        )
        
        Nuke.loadImage(with: request, into: cell.imageView) { result in
            if case .success = result {
                cell.removeGradient()
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == gifs.count - 20, !reachedLimit {
            DispatchQueue.global(qos: .utility).async {
                self.presenter?.fetchGifs(for: self.selectedCategory)
            }
        }
        let offset = collectionView.contentOffset.y
        let frameHeight = collectionView.frame.height
        setArrowView(visible: offset > frameHeight)
    }
}

//MARK: - Collection View Flow Layout

extension GalleryViewController: MosaicLayoutDelegate {

    func heightForGif(at indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let gifHeight = calculateHeight(for: gifs[indexPath.row], scaledToWidth: cellWidth)
        return gifHeight
    }

    private func calculateHeight(for gif: Gif, scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = CGFloat(Float(gif.downsized.width ?? "100") ?? 0)
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = CGFloat(Float(gif.downsized.height ?? "100") ?? 0) * scaleFactor
        return newHeight
    }
}

//MARK: - Collection View Delegate Methods

extension GalleryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.openGifViewController(for: gifs[indexPath.row])
    }
    
}
