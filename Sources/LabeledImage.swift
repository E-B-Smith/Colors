//
//  LabeledImage.swift
//  Colors
//
//  Created by Stephanie Lee on 4/28/21.
//

import Foundation
import UIKit

final class LabeledImage: UIView {
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 5.0
        return imageView
    }()

    init(text: String, image: UIImage) {
        super.init(frame: .zero)
        label.text = text
        imageView.image = image

        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageView.topAnchor.constraint(equalTo: label.bottomAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
