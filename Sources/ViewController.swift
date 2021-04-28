//
//  ViewController.swift
//  Colors
//
//  Created by Edward Smith on 4/25/21.
//
import UIKit

extension UIImage {
    convenience init(safe: String) {
        if let _ = UIImage(named: safe) {
            self.init(named: safe)!
        }
        self.init(named: "cry.png")!
    }
}

final class LabeledImage: UIView {
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
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
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let scrollView = UIScrollView()
        scrollView.backgroundColor = .gray

        let stackView = UIStackView(arrangedSubviews: [
            plainLogo(),
            enhancedLogo()
        ])

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func plainLogo() -> UIView {
        let image = try? UIImage(named: "AppleLogo")!
                .aspectFit(size: CGSize(width: 120.0, height: 120.0))
        let labeledImage = LabeledImage(text: "Plain", image: image!)

        return labeledImage
    }

    private func enhancedLogo() -> UIView {
        let image = try? UIImage(named: "AppleLogo")!
            .aspectFit(size: CGSize(width: 120.0, height: 120.0))
            .replace(colors: [
                (UIColor(red: 243/255, green: 187/255, blue: 75/255, alpha: 1.0), .darkGray),
                (UIColor(red: 206/255, green: 72/255, blue:69/255, alpha: 1.0), .black),
            ], tolerance: 0.01)
        let labeledImage = LabeledImage(text: "Enhanced", image: image!)

        return labeledImage
    }
}
