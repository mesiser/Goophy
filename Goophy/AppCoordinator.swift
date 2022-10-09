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
}

// MARK: - App Coordinator Output Methods

extension AppCoordinator: AppCoordinatorOutput {
    
    func openGifViewController(for gif: Gif) {
        let gifViewController = GifViewController.instantiate(fromAppStoryboard: .Main)
        gifViewController.gif = gif
        navigationController.pushViewController(gifViewController, animated: true)
    }
}
