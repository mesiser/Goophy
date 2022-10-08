//
//  GifCell.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Gifu
import UIKit

final class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: GIFImageView!
    
    private var gradientLayer: CAGradientLayer?

    func shimmer() {
        let colors: (UIColor, UIColor) = UIColor.randomTuple
        let backgroundColor = colors.0
        let gradientColor = colors.1
        imageView.backgroundColor = backgroundColor
        addGradient(for: backgroundColor, gradientColor: gradientColor)
        addAnimation()
    }
    
    private func addGradient(for color: UIColor, gradientColor: UIColor) {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = self.bounds
        gradientLayer?.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer?.colors = [gradientColor.cgColor, color.cgColor, gradientColor.cgColor]
        gradientLayer?.locations = [0.0, 0.5, 1.0]
        if let gradientLayer = gradientLayer {
            imageView.layer.addSublayer(gradientLayer)
        }
    }
    
    private func addAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.5
        gradientLayer?.add(animation, forKey: animation.keyPath)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func removeGradient() {
        imageView.layer.removeAllAnimations()
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        layer.shouldRasterize = false
    }
    
    override func prepareForReuse() {
        imageView.prepareForReuse()
        imageView.image = nil
        removeGradient()
    }
}
