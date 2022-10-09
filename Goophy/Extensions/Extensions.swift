//
//  Extension.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Combine
import Gifu
import Nuke
import UIKit

typealias Handler<T> = (T) -> Void

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

extension UIViewController {
    
    enum AppStoryboard : String {
        case Main
        
        var storyboard : UIStoryboard {
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
        }
        
        func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
            let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
            return storyboard.instantiateViewController(withIdentifier: storyboardID) as! T
        }
    }
    
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

extension Data {
    
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

extension Publisher {
    func sink(result: @escaping Handler<Result<Output, Failure>>) -> AnyCancellable {
        sink { comlpetion in
            guard case let .failure(error) = comlpetion else {
                return
            }
            result(.failure(error))
        } receiveValue: {
            result(.success($0))
        }
    }
}

extension Gif {
    func imageProcessors() -> [ImageProcessing] {
        
        let width = CGFloat(Float(downsized.width ?? "100") ?? 0)
        let height = CGFloat(Float(downsized.height ?? "100") ?? 0)
        let imageSize = CGSize(width: width, height: height)
        let resizedImageProcessors: [ImageProcessing] = [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
       
        return resizedImageProcessors
    }
}

