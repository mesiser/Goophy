//
//  AppCoordinator.swift
//  Goophy
//
//  Created by Vadim Shalugin on 09.10.2022.
//

import Nuke
import UIKit

protocol AppCoordinatorInput: AnyObject {
    func start()
}

public protocol AppCoordinatorOutput: AnyObject {
    func openGifViewController(for: Gif)
}

final class AppCoordinator: AppCoordinatorInput {
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        self.navigationController = navigationController
    }

    func start() {
        let galleryViewContoller = GalleryViewController.instantiate(fromAppStoryboard: .Main)
        galleryViewContoller.coordinator = self
        navigationController.pushViewController(galleryViewContoller, animated: false)
    }
    
    func openGifViewController(for gif: Gif, with processors: [ImageProcessing]) {
        let gifViewController = GifViewController.instantiate(fromAppStoryboard: .Main)
        gifViewController.gif = gif
        gifViewController.imageProcessors = processors
        navigationController.pushViewController(gifViewController, animated: true)
    }
}
