//
//  Extension.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Gifu
import UIKit

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIColor {
    
    static var randomTuple: (UIColor, UIColor) {
        let randomNumberOne = Float.random(in: 0 ..< 1)
        let randomNumberTwo = Float.random(in: 0 ..< 1)
        let randomNumberThree = Float.random(in: 0 ..< 1)
        let colorOne = UIColor(
            red: CGFloat(randomNumberOne),
            green: CGFloat(randomNumberTwo),
            blue: CGFloat(randomNumberThree),
            alpha: 1
        )
        let colorTwo = UIColor(
            red: CGFloat(randomNumberOne - 0.1),
            green: CGFloat(randomNumberTwo - 0.1),
            blue: CGFloat(randomNumberThree - 0.1),
            alpha: 1
        )
        return (colorOne, colorTwo)
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

extension Gifu.GIFImageView {
    public override func nuke_display(image: UIImage?, data: Data? = nil) {
        prepareForReuse()
        if let data = data {
            animate(withGIFData: data)
        } else {
            self.image = image
        }
    }
}
