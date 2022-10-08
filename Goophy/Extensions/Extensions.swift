//
//  Extension.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import UIKit

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

enum AppStoryboard : String {
    case Main = "Main"
    
    var storyboard : UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return storyboard.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
