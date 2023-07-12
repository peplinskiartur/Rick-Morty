//
//  GradientView.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 10/07/2023.
//

import UIKit

final class GradientView: UIView {
    var startColor: UIColor = .black { didSet { updateColors() }}
    var endColor: UIColor = .white { didSet { updateColors() }}
    var startLocation: Double = 0.0 { didSet { updateLocations() }}
    var endLocation: Double = 1.0 { didSet { updateLocations() }}
    var startPoint: CGPoint = .init(x: 0.5, y: 0)
    var endPoint: CGPoint = .init(x: 0.5, y: 1)

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    private func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }

    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}

